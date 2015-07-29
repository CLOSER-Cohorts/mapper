class Variable < ActiveRecord::Base
  belongs_to :instrument
  has_many :questions, :through => :map, :source => :mapable, source_type: "Question"
  has_many :map, :dependent => :destroy
  has_many :src, -> {where mapable_type: 'Variable'}, :class_name => 'Map', :foreign_key => 'mapable_id', :dependent => :destroy
  has_many :src_variables, :through => :map, :source => :mapable, source_type: "Variable"
  has_many :out_variables, :through => :src, :source => :variable
  has_one :topic, through: :link, as: :target
  has_one :link, :as => :target, :dependent => :destroy

  include Linking

  def get_topic
    if topic.nil?
      return get_parent_topic
    else
      return topic
    end
  end
  
  def get_topic
    if topic.nil?
      if out_variables.count > 0
        o_topic = nil
        out_variables.each do |var|
          if not var.get_topic.nil?
            if o_topic.nil?
              o_topic = var.get_topic
            else
              if o_topic != var.get_topic
                raise "The variable have mixed topics. This is a no no."
              end
            end
          end
        end
        
        p_topic = get_parent_topic
        if o_topic.nil?
          return p_topic
        else
          if o_topic == p_topic
            return o_topic
          else
            raise "The variable have mixed topics. This is a no no."
          end
        end
      else
        return get_parent_topic
      end
    else
      return topic
    end
  end

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
      good = good && integrity_check(questions, new_topic)
      good = good && integrity_check(src_variables, new_topic)
      good = good && integrity_check(out_variables, new_topic)
    end
    if good
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
    
    to_check = questions.reject{|x| exclude.include? x}
    to_check += src_variables.reject{|x| exclude.include? x}
    to_check += out_variables.reject{|x| exclude.include? x}
    
    to_check.each do |x|
      if x.topic.nil? || x.topic == topic || topic.nil?
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
