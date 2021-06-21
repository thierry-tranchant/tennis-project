class FillParticipantsAndCreateFirstRoundGamesJob < ApplicationJob
  queue_as :default

  def perform
    scrapps = Scrapp.where(state: 'current')
    scrapps.each do |scrapp|
      next unless scrapp.participants.count.zero?

      puts "#{scrapp.tournament_location} (year: #{scrapp.tournament_year}) successfully loaded..."
      Participant.fill_draw(scrapp, "https://www.atptour.com/en/scores/current/#{scrapp.tournament_location}/#{scrapp.tournament_number}/draws")
      scrapp = scrapp.reload
      scrapp.initialize_games
      scrapp = scrapp.reload
      scrapp.fill_first_round_games
    end
    puts "Job's finished!"
  end
end
