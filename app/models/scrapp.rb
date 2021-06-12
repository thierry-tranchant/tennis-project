require 'open-uri'
require 'nokogiri'

BASE_URL = "https://www.atptour.com/en/tournaments"

class Scrapp < ApplicationRecord
  has_many :participants
  has_many :tournaments

  def self.fetch_tournaments_data(tournament_year)
    html_file = URI.open(BASE_URL).read
    html_doc = Nokogiri::HTML(html_file)

    Scrapp.create_scrapp_record(html_doc, tournament_year)
  end

  def self.create_scrapp_record(html_doc, tournament_year)
    index = 1
    html_doc.search('.tourney-result').each do |element|
      url = element.search('.tourney-title').attribute('href').value
      tournament_name = element.search('.tourney-title').attribute('data-ga-label').value
      tournament_location = url.split('/')[3]
      tournament_number = url.split('/')[4].to_i
      draw_url = "https://www.atptour.com/en/scores/archive/#{tournament_location}/#{tournament_number}/#{tournament_year}/draws"
      start_date = Date.parse(element.search('.tourney-dates').text.split('-')[0].strip)
      end_date = Date.parse(element.search('.tourney-dates').text.split('-')[1].strip)
      Scrapp.create(tournament_name: tournament_name, tournament_location: tournament_location, tournament_number: tournament_number, draw_url: draw_url, start_date: start_date, end_date: end_date, index: index, drawed: false, tournament_year: tournament_year)
      index += 1
    end
  end

  private_class_method :create_scrapp_record
end
