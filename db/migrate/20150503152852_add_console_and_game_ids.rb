class AddConsoleAndGameIds < ActiveRecord::Migration
  def up
    add_column :consoles, :game_id, :integer
    add_column :games, :console_id, :integer
  end

  def down
    remove_column :games, :console_id
    remove_column :consoles, :game_id
  end

end
