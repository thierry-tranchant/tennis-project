class Prono < ApplicationRecord
  belongs_to :game
  belongs_to :user
  belongs_to :winner, class_name: 'Tennisplayer'

  ROUNDS_NUMBER = [64, 32, 16, 8, 4, 2, 1]

  def previous_game(scrapp)
    last_round = ROUNDS_NUMBER[ROUNDS_NUMBER.index(game.round) - 1]
    p last_round
    games = Game.where(scrapp: scrapp, round: last_round)
    p games
    p winner.id
    p result = games.find { |match| match.first_player == winner || game.second_player == winner }
    result
  end

  def background_color_prono_box
    if winner == game.winner
      '#387053'
    elsif game.winner == Tennisplayer.find_by(tennisplayer_url: 'fake_player')
      '#ff6e40'
    else
      '#FD1015'
    end
  end

  def background_color_winner_box
    if game.winner == Tennisplayer.find_by(tennisplayer_url: 'fake_player')
      '#ff6e40'
    else
      'white'
    end
  end

  def border_winner_box;
    if winner == game.winner
      '1px solid #387053'
    elsif game.winner == Tennisplayer.find_by(tennisplayer_url: 'fake_player')
      'none'
    else
      '1px solid #FD1015'
    end
  end
end
