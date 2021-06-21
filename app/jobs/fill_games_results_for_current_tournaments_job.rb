class FillGamesResultsForCurrentTournamentsJob < ApplicationJob
  queue_as :default

  def perform
    scrapps = Scrapp.where(state: 'current', drawed: true)
    scrapps.each { |scrapp| scrapp.fill_games_results("https://www.atptour.com/en/scores/current/#{scrapp.tournament_location}/#{scrapp.tournament_number}/results") }
  end
end
