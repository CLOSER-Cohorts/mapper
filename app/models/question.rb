class Question < ActiveRecord::Base
  belongs_to :instrument
  has_many :map, as: :mapable
end
