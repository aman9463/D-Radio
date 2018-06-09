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


  validates_presence_of :name, :description
end
