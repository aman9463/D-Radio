class Room < ApplicationRecord

		extend FriendlyId
	friendly_id :slug_candidates, use: [:slugged, :finders]

	def slug_candidates
    [
      :name,
      [:name]
    ]
  end


  belongs_to :user
  has_many :room_tags
  has_many :tags, through: :room_tags
# accepts_nested_attributes_for :room_tags, :allow_destroy => true
  validates_presence_of :name, :description
end
