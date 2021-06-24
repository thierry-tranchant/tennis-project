class FillParticipantsAndCreateFirstRoundGamesJob < ApplicationJob
  queue_as :default

  def perform
    scrapps = Scrapp.where(state: 'current')
    scrapps.each do |scrapp|
      next unless scrapp.participants.count.zero?

      begin
        Participant.fill_draw(scrapp, "https://www.atptour.com/en/scores/current/#{scrapp.tournament_location}/#{scrapp.tournament_number}/draws")
        puts "#{scrapp.tournament_location} (year: #{scrapp.tournament_year}) successfully loaded..."
        scrapp = scrapp.reload
        scrapp.initialize_games
        scrapp = scrapp.reload
        scrapp.fill_first_round_games
      rescue => e
        scrapp.participants.destroy_all
        scrapp.games.destroy_all
        puts "\n\n\n\n\n #{e.class}"
        puts "#{e.message} \n\n\n\n\n"
      end
    end
    puts "Job's finished!"
  end
end
