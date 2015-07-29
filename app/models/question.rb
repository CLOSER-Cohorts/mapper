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
      if variables.count > 0
        v_topic = nil
        variables.each do |var|
          if not var.get_topic.nil?
            if v_topic.nil?
              v_topic = var.get_topic
            else
              if v_topic != var.get_topic
                raise "The question have mixed topics. This is a no no."
              end
            end
          end
        end
        
        if v_topic.nil?
          return get_parent_topic
        else
          return v_topic
        end
      else
        return get_parent_topic
      end
    else
      return topic
    end
  end

  def get_parent_topic
    return parent.get_topic
  end

  def set_topic( new_topic )
    if integrity_check(variables, new_topic) || new_topic.nil?
      association(:topic).writer(new_topic)
    else
      raise "Cannot assign topic"
    end
  end
  alias topic= set_topic
  
  def topic_nest_is_valid
    return topic_nest_is_valid_worker([], nil)[0]
  end
  
  def topic_nest_is_valid_worker ( exclude , running_topic )
    exclude.push(self)
	
	 if not topic.nil?
      if running_topic.nil?
        running_topic = topic
      else
        if running_topic != topic
          return false, exclude, running_topic
        end
      end  
    end
	
    to_check = variables.reject{|x| exclude.include? x}
    
    to_check.each do |x|
      if x.topic.nil? || x.topic == topic
        result, exclude, running_topic = x.topic_nest_is_valid_worker(exclude, running_topic)
        if not result
          return false, exclude, running_topic
        end
      else
        return false, exclude, running_topic
      end
    end
    
    return true, exclude, running_topic
  end
end
