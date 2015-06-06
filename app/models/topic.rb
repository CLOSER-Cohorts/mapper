class Topic < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Topic'
  has_many :children, :class_name => 'Topic', :foreign_key => 'parent_id'
end
