class PronosController < ApplicationController
  def index
    @scrapps = Srapp.pronos.where(user: User.find_by(username: params[:username]))
  end

  def new
    @scrapp = Scrapp.find(params[:scrapp_id])
    @pronos = []
    fake_player = Tennisplayer.find_by(tennisplayer_url: 'fake_player')
    @scrapp.games.each do |game|
      prono = Prono.new(game: game, user: User.find_by(username: params[:username]), winner: fake_player)
      authorize prono
      @pronos << prono
    end
    @rounds = [64, 32, 16, 8, 4, 2, 1].select { |number| number <= @scrapp.games.find_by(index: 1).round }
  end

  def create
    pronos = []
    params.each do |key, player|
      next unless /prono-[0-9]+/.match?(key)

      prono = create_prono(key, player)
      authorize prono
      # render "/#{params[:username]}/pronos/#{scrapp.id}/new" && return unless prono.valid?
      pronos << prono
    end
    pronos.each(&:save!)
    redirect_to username_pronos_scrapp_path
  end

  def show
    @scrapp = Scrapp.find(params[:scrapp_id])
    @pronos = Prono.where(user: User.find_by(username: params[:username])).select { |prono| prono.game.scrapp == @scrapp }
    @pronos.each { |prono| authorize prono }
    @rounds = [64, 32, 16, 8, 4, 2, 1].select { |number| number <= @scrapp.games.find_by(index: 1).round }
  end

  private

  def create_prono(key, player)
    winner = Tennisplayer.find_by(first_name: player.split[0], last_name: player.split[1..].join(' '))
    scrapp = Scrapp.find(params[:scrapp_id])
    game = Game.find_by(index: /[0-9]+/.match(key)[0], scrapp: scrapp)
    winner == game.first_player ? game.second_player : game.first_player
    Prono.new(winner: winner, game: game, user: User.find_by(username: params[:username]))
  end
end
