module Linking

  @@lock = Mutex.new
  def self.topic_nests
    Rails.cache.fetch(:topic_nests) do
       []
    end
  end
  
  def self.topic_nests=(all_nests)
    Rails.cache.write(:topic_nests, all_nests)
  end
  
  def my_nest
    return Linking::topic_nests.find { |nest| nest[:members].include? self.class.name + self.id.to_s }
  end
  
  def get_topic
    if topic_nest_is_valid
      return my_nest[:topic]
    else
      raise "The topic nest has mixed topics. This is a no no."
    end
  end
  
  def topic_nest_is_valid
    topic_nest = my_nest
    if topic_nest == nil
      @@lock.synchronize do
        all_nests = Linking::topic_nests
        all_nests << topic_nest_is_valid_worker({topic: nil, members: [], good: true, fixed_points: []})
        Linking::topic_nests = all_nests
      end
      topic_nest = all_nests.last
    end
    return topic_nest[:good]
  end
  
  def topic_nest_is_valid_worker ( nest )
    if not nest[:members].include? self.class.name + self.id.to_s
      nest[:members] << self.class.name + self.id.to_s
    end
	
	if not topic.nil?
      if nest[:topic].nil?
        nest[:topic] = topic
      else
        if nest[:topic] != topic
          nest[:good] = false
        end
      end 
      nest[:fixed_points] << {type: self.class.name, id: self.id, obj: self, topic: topic}
    end
	
    to_check = get_relations.reject{|x| nest[:members].include? x.class.name + x.id.to_s}
    to_check.each do |x|
      if x.topic.nil? || x.topic == topic || nest[:topic].nil?
        nest = x.topic_nest_is_valid_worker(nest)
      else
        nest[:good] = false
        nest[:fixed_points] << {type: x.class.name, id: x.id, obj: x, topic: x.topic}
      end
    end
    
    return nest
  end

  def integrity_check (list, new_topic)
    list.each do |item|
      if not item.topic.nil?
        if item.topic != new_topic
          return false
        end
      end
    end
    return true
  end
  
  def clear_nest
    if not my_nest.nil?
      @@lock.synchronize do
        all_nests = Linking::topic_nests
        all_nests.delete_if { |nest| nest[:members].include? self.class.name + self.id.to_s }
        Linking::topic_nests = all_nests
      end
    end
  end
end
