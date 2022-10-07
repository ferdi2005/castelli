class Castle < ApplicationRecord
    validates :qid, uniqueness: true
    
end
