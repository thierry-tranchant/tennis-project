class PronosController < ApplicationController
  def index

  end

  def new
    @scrapp = Scrapp.find(params[:scrapp_id])
    @pronos = []
    fake_player = Tennisplayer.find_by(tennisplayer_url: 'fake_player')
    @scrapp.games.each do |game|
      prono = Prono.new(game: game, user: User.find_by(username: params[:username]), winner: fake_player, loser: fake_player)
      authorize prono
      @pronos << prono
    end
    @rounds = [64, 32, 16, 8, 4, 2, 1].select { |number| number <= @scrapp.games.find_by(index: 1).round }
  end

  def create
    raise
  end

  def show

  end
end
