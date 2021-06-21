require 'open-uri'
require 'nokogiri'

class Participant < ApplicationRecord
  belongs_to :scrapp
  belongs_to :tennisplayer



  def self.create_participants_from_draw_table(html_doc, scrapp)
    html_doc.search('#scoresDrawTable tbody').first.search('> tr').each do |table_row|
      table_row.search('.scores-draw-entry-box').first.search('tr').each do |tr|
        index = tr.search('td').to_a[0].text.strip
        seed = /[0-9]+/.match(tr.search('td').to_a[1].text.strip).to_s
        qualified = /Q/.match?(tr.search('td').to_a[1].text.strip)
        wildcard = /WC/.match?(tr.search('td').to_a[1].text.strip)
        luckyloser = /LL/.match?(tr.search('td').to_a[1].text.strip)
        first_name = tr.search('td').to_a[2].text.strip.split[0]
        first_name = 'Bye' if /Bye/.match?(first_name)
        last_name = tr.search('td').to_a[2].text.strip.split[1..].join(' ')
        case first_name
        when 'Bye' then url = 'Bye'
        when 'Lucky' then url = 'Lucky'
        else
          url = tr.search('td a').attribute('href').value
        end
        tennisplayer = Tennisplayer.find_by(tennisplayer_url: url)
        if tennisplayer.nil?
          player_infos = Tennisplayer.scrapp_from_players_page(url)
          tennisplayer = Tennisplayer.create(first_name: first_name, last_name: last_name, tennisplayer_url: url, age: player_infos[:age], nationality: player_infos[:nationality], birthdate: player_infos[:birthdate], weight: player_infos[:weight], height: player_infos[:height], handed: player_infos[:handed], backhand: player_infos[:backhand])
        end
        Participant.create(tennisplayer: tennisplayer, scrapp: scrapp, seed: seed, qualified: qualified, wildcard: wildcard, luckyloser: luckyloser, index: index)
      end
    end
  end

  class << self
    private :create_participants_from_draw_table
  end

  def self.fill_draws_for_finished
    finished_tournaments = Scrapp.where(state: 'finished')
    finished_tournaments.each do |scrapp|
      html_file = URI.open(scrapp.draw_url).read
      html_doc = Nokogiri::HTML(html_file)
      create_participants_from_draw_table(html_doc, scrapp)
    end
  end

  def self.fill_draws_for_finished_from(id)
    finished_tournaments = Scrapp.where("state = 'finished' AND id >= ?", id)
    finished_tournaments.each do |scrapp|
      html_file = URI.open(scrapp.draw_url).read
      html_doc = Nokogiri::HTML(html_file)
      create_participants_from_draw_table(html_doc, scrapp)
    end
  end

  def self.fill_draw(scrapp, url)
    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML(html_file)
    create_participants_from_draw_table(html_doc, scrapp)
  end
end
