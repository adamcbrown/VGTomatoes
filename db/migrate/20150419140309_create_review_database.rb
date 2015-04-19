class CreateReviewDatabase < ActiveRecord::Migration
  def up
    create_table :reviews do |t| 
      t.integer :rating
      t.text :description
    end
  end

  def down
    drop_table :reviews
  end
end
