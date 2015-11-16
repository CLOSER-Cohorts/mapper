# The variable model represents a data variable within DDI. Primary these need to be 
# mapped to questions and other variables and have a topic assigned.
class Variable < ActiveRecord::Base
  belongs_to :instrument
  has_many :questions, :through => :map, :source => :mapable, source_type: "Question"
  has_many :map, :dependent => :destroy
  has_many :src, -> {where mapable_type: 'Variable'}, :class_name => 'Map', :foreign_key => 'mapable_id', :dependent => :destroy
  has_many :src_variables, :through => :map, :source => :mapable, source_type: "Variable"
  has_many :out_variables, :through => :src, :source => :variable
  has_one :topic, through: :link, as: :target
  has_one :link, :as => :target, :dependent => :destroy
  
  # X and Y coordinates allow the coordinates of the mapping connection to be attributed
  # to the variable.
  attr_accessor :x, :y

  include Linking
  
  # Returns the topic of the first object that this variable is derived from.
  def get_parent_topic
    if var_type == 'Normal'
      if questions.count > 0
        return questions.first.get_topic
      else
        return nil
      end
    else
      if src_variables.count > 0 
        return src_variables.first.get_topic
      else
        return nil
      end
    end
  end

  # Returns whether the variable has a source object (aka has a parent).
  def has_source
    return (questions.count + src_variables.count) > 0
  end

  # Connects or removes a topic. Pass nil to remove a topic.
  #
  #   question.set_topic(physical_health)
  #   question.set_topic(Nil:nil)
  def set_topic( new_topic )
    if integrity_check(get_relations, new_topic) || new_topic.nil?
      association(:topic).writer(new_topic)
    else
      raise "Cannot assign topic"
    end
    clear_nest
  end
  alias topic= set_topic
  
  # Returns all related siblings.
  def get_relations
    questions + src_variables + out_variables
  end
end
