class ResetParticipantsWhileQualifiedAndLuckyloserInDrawJob < ApplicationJob
  queue_as :default

  def perform
    scrapps = Scrapp.where(state: 'current')
    scrapps.each do |scrapp|
      next unless scrapp.participants.map { |participant| participant.tennisplayer.last_name }.any? { |name| ['Qualified', 'Lucky'].include?(name) }

      begin
        scrapp.participants.destroy_all
        scrapp.games.destroy_all
        Participant.fill_draw(scrapp, "https://www.atptour.com/en/scores/current/#{scrapp.tournament_location}/#{scrapp.tournament_number}/draws")
        puts "#{scrapp.tournament_location} (year: #{scrapp.tournament_year}) successfully loaded..."
        puts "https://www.atptour.com/en/scores/current/#{scrapp.tournament_location}/#{scrapp.tournament_number}/draws"
        Participant.fill_draw(scrapp, "https://www.atptour.com/en/scores/current/#{scrapp.tournament_location}/#{scrapp.tournament_number}/draws")
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
