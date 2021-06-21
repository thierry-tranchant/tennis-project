class SetScrappDrawedJob < ApplicationJob
  queue_as :default

  def perform
    scrapps = Scrapp.where(state: 'current')
    puts "Successfully loaded #{scrapps.count} scrapps..."
    scrapps.each do |scrapp|
      scrapp.drawed = true
      scrapp.save
      puts "Successfully made #{scrapp.tournament_location} (year: #{scrapp.tournament_year}) drawed !"
    end
  end
end
