# The linking module contains a set of common methods that are used by both variables and
# questions in order to link topics.
module Linking

  # This submits a new topic nest to the cache and creates an index in the cache so that
  # the nest can be found quickly.
  #
  # ==== Attributes
  #
  # * +new_nest+ - topic nest to be submitted to the cache
  def add_topic_nest(new_nest)
    index = 'topic_nest_' + new_nest[:members][0]
    Rails.cache.write(index, new_nest)
    new_nest[:members].each do |member|
      Rails.cache.write('topic_nest_index_' + member, index)
    end
  end
  
  # Retrieves the nest that this object relates to from the cache.
  def my_nest
    index = Rails.cache.read('topic_nest_index_' + self.class.name + self.id.to_s)
    logger.debug index
    if index.nil?
      return
    end
    Rails.cache.read(index)
  end
  
  # Returns the topic from this objects topic nest. This method will also cause a topic 
  # nest to be generated if needed.
  def get_topic
    if topic_nest_is_valid
      return my_nest[:topic]
    else
      raise "The topic nest has mixed topics. This is a no no."
    end
  end
  
  # Determines if the object's topic nest is valid, i.e. passes all integrity checks. If
  # the object doesn't have a topic nest yet, then it will cause one to be generated.
  def topic_nest_is_valid
    topic_nest = my_nest
    if topic_nest.nil?
      topic_nest =  topic_nest_is_valid_worker({topic: nil, members: [], good: true, fixed_points: []})
      add_topic_nest(topic_nest)
    end
    return topic_nest[:good]
  end
  
  # This protected method is only used by +topic_nest_is_valid+ to generate a topic nest.
  def topic_nest_is_valid_worker ( nest )
    if not nest[:members].include? self.class.name + self.id.to_s
      nest[:members] << self.class.name + self.id.to_s
    else
      return nest
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
      if (not x.topic.nil?) && x.topic != topic && (not nest[:topic].nil?)
        nest[:good] = false
      end
      logger.debug x
      nest = x.topic_nest_is_valid_worker(nest)
    end
    return nest
  end

  # Checks that a new topic does not violate the integrity rules of any object in the
  # given list
  #
  # ==== Attributes
  #
  # * +list+ - list of questions and variables to be checked against
  # * +new_topic+ - proposed new topic
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
  
  # Deletes this objects topic nest from the cache to allow it be regenerated when next 
  # needed.
  def clear_nest
    if not my_nest.nil?
      index = Rails.cache.read('topic_nest_index_' + self.class.name + self.id.to_s)
      if index.nil?
        return
      end
      Rails.cache.delete(index)
    end
  end
  
  protected :topic_nest_is_valid_worker
end
