class Question < ActiveRecord::Base
  belongs_to :instrument
  belongs_to :parent, class_name: "Sequence", foreign_key: "parent_id"
  has_many :variables, :through => :map, :as => :mapable
  has_many :map, :as => :mapable, :dependent => :destroy 
  has_one :topic, through: :link, as: :target
  has_one :link, :as => :target, :dependent => :destroy

  validates :qc, :uniqueness => {:scope => :instrument_id}

  include Linking

  def get_comma_separated_variables
    var_names = []
    variables.each do |variable|
      var_names.push(variable.name)
    end
    return var_names.join(',')
  end
  
  def get_topic
    output = super
    p_topic = get_parent_topic
    if output.nil? && (not p_topic.nil?)
      output = p_topic
    end
    return output
  end

  def get_parent_topic
    if parent.nil?
      return
    else
      return parent.get_topic
    end
  end

  def set_topic( new_topic )
    if integrity_check(variables, new_topic) || new_topic.nil?
      association(:topic).writer(new_topic)
    else
      raise "Cannot assign topic"
    end
  end
  alias topic= set_topic
  
  def get_relations
    variables
  end
  
  def variables_with_coords
    vars = []
    map.all.each do |junc|
      vars.push(junc.variable)
      vars.last.x = junc.x
      vars.last.y = junc.y
    end
    return vars
  end
  
  def parent_reference
    if parent.nil?
      return 'none'
    else
      return parent.URN
    end
  end
  
  def count_outs
    r = Question.count_by_sql("SELECT COUNT(*) FROM maps WHERE mapable_type='Question' AND mapable_id = " + id.to_s)
  end
end
