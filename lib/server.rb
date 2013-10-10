require 'sinatra'
require 'sinatra/activerecord'
require 'json'

require_relative 'game'
require_relative 'move'


ENV['DATABASE_URL'] ||= "sqlite3:///database.sqlite"

class Server < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  set :database, ENV['DATABASE_URL']

  get '/' do
    "Game Server - Home"
  end

  get '/games' do
    games = Game.all.find_all {|game| game.open? }
    games_data = games.map {|game| { id: game.id, player_one: game.player_one } }
    games_data.to_json
  end

  # Input: { player_one: "name" }
  post '/games' do
    game = Game.create!(player_one: params[:player_one])
    { created: true, id: game.id }.to_json
  end

  # Input: { player_two: "name" }
  put '/games/:id' do
    game = Game.find(params[:id])
    if game
      game.player_two = params[:player_two]
      game.save
      { joined: true, id: game.id, player_one: game.player_one }.to_json
    else
      { joined: false, id: game.id }.to_json
    end
  end

  # Input: { data: "1,1,x" }
  get '/games/:id/moves' do
    game = Game.find(params[:id])
    moves = game.moves.map {|move| move.data}
    { id: game.id, moves: moves }.to_json
  end

  get '/games/:id/moves/last' do
    game = Game.find(params[:id])
    last_move = game.moves.all.last
    { id: game.id, move: last_move.data }.to_json
  end

  # data: "1,1,x"
  # data: "2,2,o"
  post '/games/:id/moves' do
    game = Game.find(params[:id])
    game.moves.create(data: params[:data])
  end

end