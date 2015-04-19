class CreateUserDatabase < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :username
      t.string :email
      t.boolean :is_critic
      t.string :date_of_birth
    end
  end

  def down
    drop_table :users
  end
end
