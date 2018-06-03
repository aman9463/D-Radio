class Room < ApplicationRecord

		extend FriendlyId
	friendly_id :slug_candidates, use: [:slugged, :finders]

	def slug_candidates
    [
      :name,
      [:name]
    ]
  end
end
