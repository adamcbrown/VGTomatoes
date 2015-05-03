class CreateConsoleDatabase < ActiveRecord::Migration
  def up
    create_table :consoles do |t|
      t.string :name
      t.string :abbreviation
    end
  end

  def down
    drop_table :consoles
  end
end
