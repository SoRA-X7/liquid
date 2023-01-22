class CreateUserRoomAuthorities < ActiveRecord::Migration[7.0]
  def change
    create_table :user_room_authorities do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.integer :role, null: false, default: 0

      t.timestamps
    end
  end
end
