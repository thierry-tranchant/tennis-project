array = [[1, 'First'], [2, 'Second'], [3, 'Third'], [4, 'Fourth'], [5, 'Fifth'], [6, 'Sixth'], [7, 'Seventh'], [8, 'Eighth'], [9, 'Ninth'], [10, 'Tenth']]

(1..10).to_a.each do |num|
  Tennisplayer.create(first_name: 'Qualified', last_name: array[num - 1][1], tennisplayer_url: 'Qualified')
  Tennisplayer.create(first_name: 'Lucky', last_name: array[num - 1][1], tennisplayer_url: 'Lucky')
end
