class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :email, null: false

      t.timestamps
    end
  end
end
