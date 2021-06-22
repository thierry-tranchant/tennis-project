require 'open-uri'
require 'nokogiri'

class Ranking < ApplicationRecord
  belongs_to :tennisplayer

  def self.fetch_atp_ranking_history(player)
    html_file = URI.open("https://www.atptour.com#{player.tennisplayer_url[0..-9]}rankings-history").read
    html_doc = Nokogiri::HTML(html_file)
    html_doc.search(".mega-table tbody tr").each do |row|
      p values = row.element_children.map { |td| td.text.strip }
      date = Date.parse(values[0])
      value = values[1]
      tennisplayer = player
      category = 'atp'
      ranking = Ranking.find_by(date: date, category: category, tennisplayer: tennisplayer)
      if ranking.nil?
        Ranking.create(date: date, value: value, tennisplayer: tennisplayer, category: category)
      else
        ranking.update(date: date, value: value, tennisplayer: tennisplayer, category: category)
      end
    end
  end

  def self.fetch_atp_ranking_history_for_db_players
    Tennisplayer.all.select { |player| player.rankings.count.zero? }.each do |player|
      next if %w[Bye Lucky Qualified fake_player].include?(player.tennisplayer_url) || player.rankings.count.positive?

      Ranking.fetch_atp_ranking_history(player)
    end
  end

  def self.fetch_race_ranking(date, range)
    days_before = (date.wday + 5) % 7 + 1
    last_monday = date.to_date - days_before
    html_file = URI.open("https://www.atptour.com/en/rankings/singles-race-to-turin?rankDate=#{last_monday.strftime('%Y-%m-%d')}&rankRange=#{range}").read
    html_doc = Nokogiri::HTML(html_file)
    html_doc.search(".mega-table tbody tr").each do |row|
      url = row.search('.player-cell a').attribute('href').value
      next if url == 'https://www.atptour.com//en/players/luis-patiño/pe42/overview'

      tennisplayer = Tennisplayer.find_by(tennisplayer_url: url)
      if tennisplayer.nil?
        player_infos = Tennisplayer.scrapp_from_players_page(url)
        first_name = row.search('.player-cell a').text.strip.split[0]
        last_name = row.search('.player-cell a').text.strip.split[1..]
        tennisplayer = Tennisplayer.create(first_name: first_name, last_name: last_name, tennisplayer_url: url, age: player_infos[:age], nationality: player_infos[:nationality], birthdate: player_infos[:birthdate], weight: player_infos[:weight], height: player_infos[:height], handed: player_infos[:handed], backhand: player_infos[:backhand])
      end
      value = row.search('.rank-cell').text.strip
      date = last_monday
      category = 'race'
      ranking = Ranking.find_by(date: date, category: category, tennisplayer: tennisplayer)
      next unless ranking.nil?

      Ranking.create(date: date, value: value, tennisplayer: tennisplayer, category: category)
    end
  end

  def self.fetch_race_ranking_history_for_current_year
    ranges = ['0-100', '101-200', '201-300', '301-400', '401-500']
    date = Date.today
    year = date.year
    while date.year == year
      ranges.each { |range| fetch_race_ranking(date, range) }
      date -= 1.week
    end
  end

  def self.fetch_race_ranking_history_for_current_year_from(date)
    ranges = ['0-100', '101-200', '201-300', '301-400', '401-500']
    year = date.year
    while date.year == year
      ranges.each { |range| fetch_race_ranking(date, range) }
      date -= 1.week
    end
  end
end
