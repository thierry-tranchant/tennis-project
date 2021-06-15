require 'open-uri'
require 'nokogiri'

class Participant < ApplicationRecord
  belongs_to :scrapp
  belongs_to :tennisplayer

  def self.fill_draws_for_finished
    url = 'https://www.atptour.com/en/scores/current/halle/500/draws'
    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML(html_file)
    html_doc.search('#scoresDrawTable tbody').first.search('> tr').each do |table_row|
      table_row.search('.scores-draw-entry-box').first.search('tr').each do |tr|
        p index = tr.search('td').to_a[0].text.strip
        p seed = /[0-9]+/.match(tr.search('td').to_a[1].text.strip).to_s
        p qualified = /Q/.match?(tr.search('td').to_a[1].text.strip)
        p wildcard = /WC/.match?(tr.search('td').to_a[1].text.strip)
        p luckyloser = /LL/.match?(tr.search('td').to_a[1].text.strip)
        p first_name = tr.search('td')[2].text.strip.split[0]
        p last_name = tr.search('td')[2].text.strip.split[1..].join(' ')
      end
    end
  end
end
