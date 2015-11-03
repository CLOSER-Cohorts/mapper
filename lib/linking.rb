module Linking

  @@lock = Mutex.new
  def add_topic_nest(new_nest)
    logger.debug 'add_topic_nest called'
    index = 'topic_nest_' + new_nest[:members][0]
    logger.debug index
    Rails.cache.write(index, new_nest)
    new_nest.members.each do |member|
      Rails.cache.write('topic_nest_index_' + member, index)
    end
  end
  
  def my_nest
    logger.debug 'my_nest called'
    index = Rails.cache.read('topic_nest_index_' + self.class.name + self.id.to_s)
    logger.debug index 
    if index.nil?
      return
    end
    Rails.cache.read(index)
  end
  
  def get_topic
    logger.debug 'get_topic called'
    if topic_nest_is_valid
      return my_nest[:topic]
    else
      raise "The topic nest has mixed topics. This is a no no."
    end
  end
  
  def topic_nest_is_valid
    logger.debug 'topic_nest_is_valid called'
    topic_nest = my_nest
    logger.debug topic_nest
    if topic_nest.nil?
      logger.debug 'topic_nest was nil'
      topic_nest =  topic_nest_is_valid_worker({topic: nil, members: [], good: true, fixed_points: []})
      logger.debug topic_nest
      add_topic_nest(topic_nest)
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
      index = Rails.cache.read('topic_nest_index_' + self.class.name + self.id.to_s)
      if index.nil?
        return
      end
      Rails.cache.delete(index)
    end
  end
end
