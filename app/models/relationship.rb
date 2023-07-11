class Relationship < ApplicationRecord
  belongs_to :follow
  belongs_to :follower
end
