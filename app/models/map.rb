class Map < ActiveRecord::Base
  belongs_to :variable
  belongs_to :mapable, polymorphic: true
end
