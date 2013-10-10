require 'faraday'
require 'json'

$connection = Faraday.new(url: "http://localhost:9393")

def available_games
  JSON.parse( $connection.get("/games").body )
end

def available_moves_for_game(id)
  JSON.parse( $connection.get("/games/#{id}/moves").body )["moves"]
end

def display_available_games
  puts "******************************************************************"
  puts " Available Games (#{available_games.count}): #{available_games}"
  puts "******************************************************************"
end

def display_moves_for_game(id)
  moves = available_moves_for_game(id)
  puts "******************************************************************"
  puts " Game #{id}"
  puts " Moves (#{moves.count}):"
  puts "#{moves.join("\n")}"
  puts "******************************************************************"
end

def make_move(game_id,move_data)
  $connection.post("/games/#{game_id}/moves",{data: move_data})
end

display_available_games

# create a game

$connection.post("/games",{ player_one: "frank"})

display_available_games

# join a game

first_available_game = available_games.first
first_available_game_id = first_available_game["id"]

puts "Joining Game: #{first_available_game_id}"
$connection.put("/games/#{first_available_game_id}",{ player_two: "martha"})

display_available_games

# get all moves

puts "Getting moves for Game: #{first_available_game_id}"

display_moves_for_game(first_available_game_id)

# make a move


puts "Making a move in game: #{first_available_game_id}"

move_data = "1,1,x"

make_move(first_available_game_id,"1,1,x")
make_move(first_available_game_id,"2,2,o")

# get all moves

display_moves_for_game(first_available_game_id)

puts "Asking for last move"

puts JSON.parse( $connection.get("/games/#{first_available_game_id}/moves/last").body )

