class Variable < ActiveRecord::Base
  belongs_to :instrument
  has_many :questions, :through => :map, :source => :mapable, source_type: "Question"
  has_many :map, :dependent => :destroy
  has_many :src, -> {where mapable_type: 'Variable'}, :class_name => 'Map', :foreign_key => 'mapable_id', :dependent => :destroy
  has_many :src_variables, :through => :map, :source => :mapable, source_type: "Variable"
  has_many :out_variables, :through => :src, :source => :variable
  has_one :topic, through: :link, as: :target
  has_one :link, :as => :target, :dependent => :destroy
  
  attr_accessor :x, :y

  include Linking
  
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

  def has_source
    return (questions.count + src_variables.count) > 0
  end

  def set_topic( new_topic )
    
    good = true
    if not new_topic.nil?
      #good = good && integrity_check(questions, new_topic)
      #good = good && integrity_check(src_variables, new_topic)
      #good = good && integrity_check(out_variables, new_topic)
    end
    if good
      association(:topic).writer(new_topic)
    else
      raise "Cannot assign topic"
    end
    clear_nest
  end
  alias topic= set_topic
  
  def get_relations
    questions + src_variables + out_variables
  end
end
