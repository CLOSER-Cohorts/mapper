class Sequence < ActiveRecord::Base
  belongs_to :instrument
  belongs_to :parent, :class_name => 'Sequence'
  has_many :children, :class_name => 'Sequence', :foreign_key => 'parent_id'
  has_many :questions, foreign_key: 'parent_id'
  has_one :topic, through: :link, as: :target
  has_one :link, :as => :target, :dependent => :destroy

  @@topics_cache = {}
  
  def get_topic
    if not @@topics_cache.has_key?(id)
      if topic.nil?
        @@topics_cache[id] = get_parent_topic
      else
        @@topics_cache[id] = topic
      end
    end
    return @@topics_cache[id]
  end
  
  def get_parent_topic
    if parent.nil?
      return nil
    else
      return parent.get_topic
    end
  end

  def parent= ( new_parent )
    if are_you_my_child(new_parent)
      raise "This would cause a circular reference"
    else
      association(:parent).writer(new_parent)
    end
  end
  
  def parent_reference
    if parent.nil?
      return 'none'
    else
      return parent.URN
    end
  end

  def are_you_my_child ( sequence )
    children.each do |child|
      if child == sequence
        return true
      end
      if child.are_you_my_child(sequence)
        return true
      end
    end
    return false
  end
end
