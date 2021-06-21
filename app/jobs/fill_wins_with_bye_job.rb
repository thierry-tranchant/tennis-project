class FillWinsWithByeJob < ApplicationJob
  queue_as :default

  def perform
    scrapps = Scrapp.where(state: 'current', drawed: true)
    scrapps.each do |scrapp|
      scrapp.games.each do |game|
        if game.first_player.tennisplayer_url == "Bye" || game.second_player.tennisplayer_url == "Bye"
          scrapp.fill_wins_against_bye(game)
        end
      end
    end
  end
end
