class CreateRoomTags < ActiveRecord::Migration[5.2]
	def change
		create_table :room_tags do |t|
			t.references :room
			t.references :tag
			t.timestamps
		end
		add_foreign_key :room_tags, :rooms, column: 'room_id', on_delete: :cascade
		add_foreign_key :room_tags, :tags, column: 'tag_id', on_delete: :cascade
	end
end
