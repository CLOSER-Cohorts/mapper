# The topic model represents a single topic from the controlled vocabulary. Each
# question, variable and sequence can be linked to a topic.
#
# The topic model self joins to create a child and parent relationship. It has 
# currently been hard coded to only accept 5 generations (or levels).
class Topic < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Topic'
  has_many :children, :class_name => 'Topic', :foreign_key => 'parent_id'

  # Returns the level of a topic
  def get_level
    level = 1
    topic_check = self
    while topic_check.parent
      level += 1
      topic_check = topic_check.parent
    end
    return level
  end

  # Returns all topics sorted by there level
  #
  # The topics are returned by first level and then id, returning both values
  # in ascending order. Children of a parent topic are returned with its parent.
  def self.get_in_level_order
    unsorted = Topic.all.order(id: 'ASC')
    sorted = {}
    parental_counter = []
    positions = {}
    unsorted.each do |topic|
      level = topic.get_level
      parent_id = topic.parent.nil? ? 0 : topic.parent.id
      parental_counter[parent_id] = parental_counter[parent_id].nil? ? 1 : parental_counter[parent_id] + 1
      position = (parental_counter[parent_id] * (100 ** (5 - level))) + (positions[parent_id].nil? ? 0 : positions[parent_id])
      positions[topic.id] = position
      sorted[position] = topic
    end
    return sorted.sort.map{|x| x[1]}
  end

  # Returns all the topics of a given level in a comma separated string.
  #
  # If a level is provided below 1 is provided, all topics will be included.
  def self.get_comma_separated_topics(level = 0)
    if level < 1
      topics = Topic.all
    else
      topics = Topic.find_by_level(level)
    end
    topic_names = []
    topics.each do |topic|
      topic_names.push(topic.name)
    end
    return topic_names.join(',')
  end

  # An addtional finder to seek by level
  def self.find_by_level(level)
    return Topic.all.select{|t| t.get_level == level}
  end
end
