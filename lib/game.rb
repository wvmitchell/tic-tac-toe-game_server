class Game < ActiveRecord::Base
  # name, player_one, player_two
  has_many :moves

  def open?
    player_two == nil
  end
end