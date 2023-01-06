class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.text :description
      t.boolean :available

      t.timestamps
    end
  end
end
