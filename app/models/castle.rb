class Castle < ApplicationRecord
    validates :qid, uniqueness: true
    reverse_geocoded_by :latitude, :longitude

end
