class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.references :game
      t.string :data
      t.timestamps
    end
  end
end
