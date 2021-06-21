class SetScrappStateJob < ApplicationJob
  queue_as :default

  def perform
    scrapps = Scrapp.where("state IN ('to_come', 'current')")
    puts 'Successfully loaded scrapps...'
    scrapps.each do |scrapp|
      scrapp.set_state if scrapp.start_date - Date.today < 1.month
      puts "Successfully changed state of #{scrapp.tournament_location} (year: #{scrapp.tournament_year}) into #{scrapp.state} !"
    end
    puts "Job's finished!"
  end
end
