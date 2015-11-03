# Junction model that connects a variable to a mapable object.
#
# The mapable objects are question and variable.
class Map < ActiveRecord::Base
  belongs_to :variable
  belongs_to :mapable, polymorphic: true
end
