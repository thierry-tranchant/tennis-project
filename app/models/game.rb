class Game < ApplicationRecord
  belongs_to :scrapp
  has_many :pronos
  belongs_to :first_player, class_name: 'Tennisplayer'
  belongs_to :second_player, class_name: 'Tennisplayer'
  belongs_to :winner, class_name: 'Tennisplayer'
  belongs_to :loser, class_name: 'Tennisplayer'

  ROUNDS_NUMBER = [64, 32, 16, 8, 4, 2, 1]

  def table_part
    return 'final' if round == 1

    part_value = index <= max_round ? index : index - ROUNDS_NUMBER.select { |number| number > round && number <= game.max_round}.sum
    part_value <= round.div(2) ? 'left' : 'right'
  end

  def grid_column
    tournament_rounds_array = [64, 32, 16, 8, 4, 2, 1].select { |number| number <= scrapp.games.find_by(index: 1).round }
    tournament_rounds_array.index(round) + tournament_rounds_array[0..tournament_rounds_array.index(round)].length
  end

  def grid_row_start
    return index if index <= round

    previous_game_index = first_player_previous_game_index
    scrapp.games.find_by(index: previous_game_index).grid_row_start
  end

  def grid_row_end
    return index if index <= round

    previous_game_index = second_player_previous_game_index
    scrapp.games.find_by(index: previous_game_index).grid_row_end
  end

  def first_player_previous_game_index
    round_diff = index - ROUNDS_NUMBER.select { |round_num| round_num > round && round_num <= max_round }.sum
    index - 2 * round + round_diff - 1
  end

  def second_player_previous_game_index
    round_diff = index - ROUNDS_NUMBER.select { |round_num| round_num > round && round_num <= max_round }.sum
    index - 2 * round + round_diff
  end

  def max_round
    scrapp.games.find_by(index: 1).round
  end

  def previous_game(previous_index)
    scrapp.games.find_by(index: previous_index)
  end
end
