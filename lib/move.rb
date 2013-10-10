class Move < ActiveRecord::Base
  belongs_to :game

  # position x,y,symbol
end