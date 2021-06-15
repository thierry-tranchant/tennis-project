require 'open-uri'
require 'nokogiri'

# BASE_URL = "https://www.atptour.com/en/tournaments"

class Scrapp < ApplicationRecord
  has_many :participants
  has_many :tournaments
  has_many :games

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
  end

  def self.fill_states
    scrapps = Scrapp.all
    scrapps.each(&:set_state)
  end



  # def self.fill_finished_tournaments
  #   # tournaments = Scrapp.where.not(state: 'finished')
  #   html_file = URI.open('https://www.atptour.com/en/scores/archive/delray-beach/499/2020/draws').read
  #   html_doc = Nokogiri::HTML(html_file)
  #   test_value = html_doc.search('.day-table').search('th').first
  #   if test_value.nil?


  #   # tournaments.each do |tournament|
  #   #    html_file = URI.open(tournament.draw_url).read
  #   # end
  #   # html_file = URI.open(BASE_URL).read
  #   # html_doc = Nokogiri::HTML(html_file)
  #   # day-table

  #   # (start_year..end_year).to_a.each do |year|

  #   # end
  #   # tournaments = Scrapp.where(tournament_year: tournament_year)
  #   # html_file = URI.open(BASE_URL).read
  #   # html_doc = Nokogiri::HTML(html_file)
  # end
end
