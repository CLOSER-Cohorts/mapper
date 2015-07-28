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
    if topic.nil?
      return get_parent_topic
    else
      return topic
    end
  end

  def get_parent_topic
    return parent.get_topic
  end

  def set_topic( new_topic )
    if integrity_check(variables, new_topic)
      topic = new_topic
    else
      raise "Cannot assign topic"
    end
  end
  alias topic= set_topic
end
