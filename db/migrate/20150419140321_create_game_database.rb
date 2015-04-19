class CreateGameDatabase < ActiveRecord::Migration
  def up
    create_table :games do |t|
      t.string :name
      t.text :description
      t.string :img_url
      t.string :ESRB_rating
    end
  end

  def down
    drop_table :games
  end
end
