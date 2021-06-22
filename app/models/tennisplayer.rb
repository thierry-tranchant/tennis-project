require 'open-uri'
require 'nokogiri'

class Tennisplayer < ApplicationRecord
  has_many :participants
  has_many :rankings
  has_many :scrapps, through: :participants
  has_and_belongs_to_many :tournaments
  has_many :wins, class_name: 'Game', foreign_key: 'winner_id'
  has_many :loses, class_name: 'Game', foreign_key: 'loser_id'
  has_many :games_as_first_player, class_name: 'Game', foreign_key: 'first_player_id'
  has_many :games_as_second_player, class_name: 'Game', foreign_key: 'second_player_id'

  BASE_URL = 'https://www.atptour.com/en/rankings/singles'

  def self.scrapp_from_players_page(url)
    player_doc = Nokogiri::HTML(URI.open("https://www.atptour.com/#{url}").read)
    nationality = player_doc.search('.player-flag-code').text.strip
    age = player_doc.search('.table-big-value').first.text.strip.to_i
    birthdate = Date.parse(player_doc.search('.table-birthday').text.strip[1..-2]) unless player_doc.search('.table-birthday').text.strip[1..-2].nil?
    weight = /[0-9]+/.match(player_doc.search('.table-weight-kg-wrapper').text.strip).to_s.to_i
    height = /[0-9]+/.match(player_doc.search('.table-height-cm-wrapper').text.strip).to_s.to_i
    unless player_doc.search('.table-value').to_a[2].text.strip == ""
      handed = player_doc.search('.table-value').to_a[2].text.strip.split(', ')[0].split('-').first.downcase
      backhand = player_doc.search('.table-value').to_a[2].text.strip.split(', ')[1].split.first.downcase
    end
    { nationality: nationality, birthdate: birthdate, weight: weight, height: height, handed: handed, backhand: backhand, age: age }
  end

  def self.scrapp_tennisplayers(url)
    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML(html_file)
    html_doc.search('.mega-table tbody').search('tr').each do |element|
      first_name = element.search('.player-cell').text.strip.split[0]
      last_name = element.search('.player-cell').text.strip.split[1..].join(" ")
      tennisplayer_url = element.search('.player-cell a').attribute('href').value
      age = element.search('.age-cell').text.strip
      player_infos = scrapp_from_players_page(tennisplayer_url)
      Tennisplayer.create(first_name: first_name, last_name: last_name, tennisplayer_url: tennisplayer_url, age: age, nationality: player_infos[:nationality], birthdate: player_infos[:birthdate], weight: player_infos[:weight], height: player_infos[:height], handed: player_infos[:handed], backhand: player_infos[:backhand])
    end
  end

  class << self
    private :scrapp_tennisplayers
  end

  def self.fetch_infos
    arrays = [[0, 100], [101, 200], [201, 300], [301, 400], [401, 500]]
    arrays.each do |array|
      scrapp_tennisplayers("#{BASE_URL}?rankDate=2021-06-14&rankRange=#{array[0]}-#{array[1]}")
    end
  end
end
