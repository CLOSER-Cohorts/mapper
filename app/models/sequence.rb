class Sequence < ActiveRecord::Base
  belongs_to :instrument
  belongs_to :parent, :class_name => 'Sequence'
  has_many :children, :class_name => 'Sequence', :foreign_key => 'parent_id'
  has_many :questions, foreign_key: 'parent_id'
  has_one :topic, through: :link, as: :target
  has_one :link, :as => :target, :dependent => :destroy

  def get_topic
    if topic.nil?
      return get_parent_topic
    else
      return topic
    end
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
