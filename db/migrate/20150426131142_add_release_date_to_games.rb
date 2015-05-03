class AddReleaseDateToGames < ActiveRecord::Migration
  def up
    add_column :games, :release_date, :string
  end

  def down
    remove_column :games, :release_date
  end
end
