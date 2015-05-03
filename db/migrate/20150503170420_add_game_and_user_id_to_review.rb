class AddGameAndUserIdToReview < ActiveRecord::Migration
  def up
    add_column :reviews, :game_id, :integer
    add_column :reviews, :user_id, :integer
  end

  def down
    remove_column :reviews, :user_id
    remove_column :reviews, :game_id
  end
end
