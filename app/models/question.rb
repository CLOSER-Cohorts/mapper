# The question model represents a single question construct that has been documented using
# DDI. It should be mapped to the variables that relate to it and have a topic assigned.
class Question < ActiveRecord::Base
  belongs_to :instrument
  belongs_to :parent, class_name: "Sequence", foreign_key: "parent_id"
  has_many :variables, :through => :map, :as => :mapable
  has_many :map, :as => :mapable, :dependent => :destroy 
  has_one :topic, through: :link, as: :target
  has_one :link, :as => :target, :dependent => :destroy

  validates :qc, :uniqueness => {:scope => :instrument_id}

  include Linking

  # Generates a list of all variable names mapped to this question as a comma separated
  # string.
  def get_comma_separated_variables
    var_names = []
    variables.each do |variable|
      var_names.push(variable.name)
    end
    return var_names.join(',')
  end
  
  # Returns the topic that should be applied to this question taking into account all of
  # the inheritance rules including topic nesting.
  def get_topic
    output = super
    p_topic = get_parent_topic
    if output.nil? && (not p_topic.nil?)
      output = p_topic
    end
    return output
  end

  # Returns the topic of the parent sequence
  def get_parent_topic
    if parent.nil?
      return
    else
      return parent.get_topic
    end
  end

  # Connects or removes a topic. Pass nil to remove a topic.
  #
  #   question.set_topic(physical_health)
  #   question.set_topic(Nil:nil)
  def set_topic( new_topic )
    if integrity_check(variables, new_topic) || new_topic.nil?
      association(:topic).writer(new_topic)
    else
      raise "Cannot assign topic"
    end
    clear_nest
  end
  alias topic= set_topic
  
  # Returns all related siblings. I.e. returns variables
  def get_relations
    variables
  end
  
  # Returns an array of variables with their Cartesian coordinates of how they were 
  # mapped.
  def variables_with_coords
    vars = []
    map.all.each do |junc|
      vars.push(junc.variable)
      vars.last.x = junc.x
      vars.last.y = junc.y
    end
    return vars
  end
  
  # Returns the URN reference of the parent sequence.
  def parent_reference
    if parent.nil?
      return 'none'
    else
      return parent.URN
    end
  end
end
