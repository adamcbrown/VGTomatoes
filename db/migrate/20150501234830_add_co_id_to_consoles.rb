class AddCoIdToConsoles < ActiveRecord::Migration
  def up
    add_column :consoles, :company_id, :integer
  end

  def down
    remove_column :consoles, :company_id
  end
end
