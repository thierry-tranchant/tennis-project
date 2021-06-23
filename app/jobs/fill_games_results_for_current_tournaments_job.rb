class FillGamesResultsForCurrentTournamentsJob < ApplicationJob
  queue_as :default

  def perform
    scrapps = Scrapp.where(state: 'current', drawed: true)

    scrapps.each do |scrapp|
      next if scrapp.participants.map { |participant| participant.tennisplayer.first_name }.any? { |name| ['Qualified', 'Lucky'].include?(name) }

      puts "Filling games results for #{scrapp.tournament_name}..."
      scrapp.fill_games_results("https://www.atptour.com/en/scores/current/#{scrapp.tournament_location}/#{scrapp.tournament_number}/results")
    end
  end
end
