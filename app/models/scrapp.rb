require 'open-uri'
require 'nokogiri'

# BASE_URL = "https://www.atptour.com/en/tournaments"

class Scrapp < ApplicationRecord
  has_many :participants
  has_many :tournaments
  has_many :games

  ROUNDS = [['finals', 1], ['semi-finals', 2], ['quarter-finals', 4], ['round of 16', 8], ['round of 32', 16], ['round of 64', 32], ['round of 128', 64]]
  ROUNDS_NUMBER = [64, 32, 16, 8, 4, 2, 1]

  def self.create_scrapp_record(html_doc, tournament_year)
    index = 1
    html_doc.search('.tourney-result').each do |element|
      url = element.search('.tourney-title').attribute('href').value
      tournament_name = element.search('.tourney-title').attribute('data-ga-label').value
      tournament_location = url.split('/')[3]
      tournament_number = url.split('/')[4].to_i
      draw_url = "https://www.atptour.com/en/scores/archive/#{tournament_location}/#{tournament_number}/#{tournament_year}/draws"
      dates = element.search('.tourney-dates').text
      if dates.include?('-')
        start_date = Date.parse(element.search('.tourney-dates').text.split('-')[0].strip)
        end_date = Date.parse(element.search('.tourney-dates').text.split('-')[1].strip)
      else
        dates_page = Nokogiri::HTML(URI.open("https://www.atptour.com/en/scores/archive/#{tournament_location}/#{tournament_number}/#{tournament_year}/results").read)
        dates_string = dates_page.search('.tourney-dates').text.split('-')
        start_date = Date.parse(dates_string[0].strip) unless dates_string[0].nil?
        end_date = Date.parse(dates_string[1].strip) unless dates_string[1].nil?
      end
      Scrapp.create(tournament_name: tournament_name, tournament_location: tournament_location, tournament_number: tournament_number, draw_url: draw_url, start_date: start_date, end_date: end_date, index: index, drawed: false, tournament_year: tournament_year)
      index += 1
    end
  end

  class << self
    private :create_scrapp_record
  end

  def self.fetch_tournaments_data(tournament_year, url)
    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML(html_file)
    create_scrapp_record(html_doc, tournament_year)
  end

  def self.fetch_past_tournaments_data(start_year, end_year)
    (start_year..end_year).to_a.each do |year|
      fetch_tournaments_data(year, "https://www.atptour.com/en/scores/results-archive?year=#{year}")
    end
  end

  def set_state
    return if start_date.nil?

    html_file = URI.open(draw_url).read
    html_doc = Nokogiri::HTML(html_file)
    test_id = html_doc.search('#scoresDrawTableContent')
    self.state = 'finished' unless test_id.empty?
    unless state == 'finished'
      html_file = URI.open("https://www.atptour.com/en/scores/current/#{tournament_location}/#{tournament_number}/draws").read
      html_doc = Nokogiri::HTML(html_file)
      test_id = html_doc.search('#scoresDrawTableContent')
      self.state = test_id.empty? ? 'to_come' : 'current'
    end
    save
  end

  def set_draw
    self.drawed = true unless participants.count.zero?
    save
  end

  def self.fill_states
    scrapps = Scrapp.all
    scrapps.each(&:set_state)
  end

  def self.fill_draw_for_finished_tournaments
    scrapps = Scrapp.all
    scrapps.each(&:set_draw)
  end

  def initialize_games
    fake_player = Tennisplayer.find_by(tennisplayer_url: 'fake_player')
    (1..participants.count - 1).to_a.each do |index|
      Game.create(scrapp: self, first_player: fake_player, second_player: fake_player, winner: fake_player, loser: fake_player, played: false, round: calculate_round(index, participants.count), index: index)
    end
  end

  def self.initialize_games_for_finished_tournaments
    scrapps = Scrapp.where(state: 'finished')
    scrapps.each(&:initialize_games)
  end

  def fill_first_round_games
    participants.select { |participant| participant.index.odd? }.each do |participant|
      index = participant.index.div(2) + 1
      game = Game.find_by(scrapp: self, index: index)
      game.update(first_player: participant.tennisplayer, second_player: Participant.find_by(scrapp: self, index: participant.index + 1).tennisplayer)
    end
  end

  def fill_games_results(url)
    html_doc = html_doc_from_url(url)
    html_doc.search('.day-table tbody').reverse.each do |tbody|
      next unless ROUNDS.map { |array| array[0] }.include?(tbody.previous_element.text.strip.downcase)

      tbody.element_children.each do |child|
        players_url = child.search('.day-table-name a').map { |link| link.attribute('href').value }
        winner = Tennisplayer.find_by(tennisplayer_url: players_url[0])
        loser = Tennisplayer.find_by(tennisplayer_url: players_url[1])
        score = child.search('.day-table-score a').text.split(/\s+/).map(&:strip).join(' ').strip
        game = update_current_game_result(winner, loser, score)
        update_next_game_participant(game, winner) unless game.index == participants.count - 1
      end
    end
  end

  def self.fill_results_for_finished_tournaments
    scrapps = Scrapp.where(state: 'finished')
    scrapps.each do |scrapp|
      scrapp.fill_first_round_games
      scrapp.fill_games_results
    end
  end

  private

  def html_doc_from_url(url)
    html_file = URI.open(url).read
    Nokogiri::HTML(html_file)
  end

  def update_current_game_result(winner, loser, score)
    game = Game.find_by(first_player: winner, second_player: loser, scrapp: self)
    game = game.nil? ? Game.find_by(first_player: loser, second_player: winner, scrapp: self) : game
    game.update(winner: winner, loser: loser, score: score, played: true)
    game = Game.find_by(first_player: winner, second_player: loser, scrapp: self)
    game.nil? ? Game.find_by(first_player: loser, second_player: winner, scrapp: self) : game
  end

  def update_next_game_participant(game, winner)
    round_diff = game.index > game.round ? game.index - ROUNDS_NUMBER.select { |round_num| round_num > game.round }.sum : game.index
    next_index = game.index + game.round - round_diff.div(2)
    next_game = Game.find_by(scrapp: self, index: next_index)
    if game.index.odd?
      next_game.update(first_player: winner)
    else
      next_game.update(second_player: winner)
    end
    p "current index: #{game.index}, next index: #{next_game.index}"
  end

  def calculate_round(index, participants_number)
    rounds = [64, 32, 16, 8, 4, 2, 1]
    rounds.find { |round| participants_number - index >= round }
  end
end
