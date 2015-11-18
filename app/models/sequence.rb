# The sequence model represents a sequence within DDI.
#
# Sequences contain questions and other sequences. There
# primary purpose is to have a topic linked, that then
# will trickle down to all immediate child questions.
#
# ==== Attributes
#
# * name - The literal text that makes up the sequence
# * URN  - The unqiue identifier reference for the project
class Sequence < ActiveRecord::Base
  belongs_to :instrument
  belongs_to :parent, :class_name => 'Sequence'
  has_many :children, :class_name => 'Sequence', :foreign_key => 'parent_id'
  has_many :questions, foreign_key: 'parent_id'
  has_one :topic, through: :link, as: :target
  has_one :link, :as => :target, :dependent => :destroy

  # Returns the topic for this sequence.
  #
  # If no topic has been assigned to this sequence, then
  # it anestory will be checked until a topic is found or
  # +Nil:nil+ will be returned if one cannot be found.
  def get_topic
    if topic.nil?
      return get_parent_topic
    else
      return topic
    end
  end
  
  # Returns the topic of the immediate parent of this
  # sequence.
  #
  # If the parent doesn't have a topic, then the
  # ancestory will be checked until a topic is found
  # or +Nil:nil+ will be returned if one cannot be 
  # found. 
  def parent_topic
    r = Topic.find_by_sql("WITH RECURSIVE tree AS (SELECT id, ARRAY[]::integer[] AS ancestors" +
    " FROM sequences WHERE parent_id IS NULL UNION ALL SELECT sequences.id, tree.ancestors" + 
    " || sequences.parent_id FROM sequences, tree WHERE sequences.parent_id = tree.id) " +
    "SELECT topics.* FROM sequences INNER JOIN links ON target_id = sequences.id AND "+
    "target_type ='Sequence' INNER JOIN topics ON topic_id = topics.id WHERE sequences.id"+
    " IN (SELECT unnest(ancestors) FROM tree WHERE id = " + id.to_s + ")")
    if r.length > 0 then r.first else nil end
  end
  alias get_parent_topic parent_topic

  # Allows parent to be set as an attribute safely.
  #
  # This method performs a check to protect against 
  # circular references.
  #
  #  sequence_one.parent = sequence_two
  def parent= ( new_parent )
    if are_you_my_child(new_parent)
      raise "This would cause a circular reference"
    else
      association(:parent).writer(new_parent)
    end
  end
  

  # Returns the URN reference for the immediate 
  # parent.
  def parent_reference
    if parent.nil?
      return 'none'
    else
      return parent.URN
    end
  end

  # Returns whether one sequence is the child of 
  # another.
  #
  # The functions works recurively checking against
  # all decdant sequences.
  #
  #  sequence_one.parent = sequence_two
  #  sequence_two.are_you_my_child sequence_one #=> true
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
