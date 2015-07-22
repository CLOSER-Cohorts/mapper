class Topic < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Topic'
  has_many :children, :class_name => 'Topic', :foreign_key => 'parent_id'

  def get_level
    level = 1
    topic_check = self
    while topic_check.parent
      level += 1
      topic_check = topic_check.parent
    end
    return level
  end

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

  def self.find_by_level(level)
    return Topic.all.select{|t| t.get_level == level}
  end
end
