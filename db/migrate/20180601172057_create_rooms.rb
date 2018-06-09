class CreateRooms < ActiveRecord::Migration[5.2]
	def change
		create_table :rooms do |t|
			t.string :name
			t.text :description
			t.string :slug
			t.references :user
			t.timestamps
		end
		add_foreign_key :rooms, :users, column: 'user_id', on_delete: :restrict
	end
end
