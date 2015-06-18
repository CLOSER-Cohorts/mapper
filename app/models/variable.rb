class Variable < ActiveRecord::Base
  belongs_to :instrument
  has_many :questions, :through => :map, :source => :mapable, source_type: "Question"
  has_many :map, :dependent => :destroy
  has_many :src, -> {where mapable_type: 'Variable'}, :class_name => 'Map', :foreign_key => 'mapable_id', :dependent => :destroy
  has_many :variables, :through => :map, :source => :mapable, source_type: "Variable"
end
