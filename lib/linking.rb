module Linking
  @@topic_nests = []

  def self.topic_nests
    @@topic_nests
  end
  
  def my_nest
    return Linking::topic_nests.find { |nest| nest[:members].include? self.id }
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
      Linking::topic_nests << topic_nest_is_valid_worker({topic: nil, members: [], good: true, fixed_points: []})
      topic_nest = Linking::topic_nests.last
    end
    return topic_nest[:good]
  end
  
  def topic_nest_is_valid_worker ( nest )
    if not nest[:members].include? self.id
      nest[:members] << self.id
    end
	
	if not topic.nil?
      if nest[:topic].nil?
        nest[:topic] = topic
      else
        if nest[:topic] != topic
          nest[:good] = false
        end
      end 
      nest[:fixed_points] << self.id 
    end
	
    to_check = get_relations.reject{|x| nest[:members].include? x.id}
    
    to_check.each do |x|
      if x.topic.nil? || x.topic == topic || nest[:topic].nil?
        nest = x.topic_nest_is_valid_worker(nest)
      else
        nest[:good] = false
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
end
