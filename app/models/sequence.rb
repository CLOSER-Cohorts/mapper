class Sequence < ActiveRecord::Base
  belongs_to :instrument
  belongs_to :parent, :class_name => 'Sequence'
  has_many :children, :class_name => 'Sequence', :foreign_key => 'parent_id'
end
