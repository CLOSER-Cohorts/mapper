# Junction model that connects a topic and a target.
#
# Targets can be any of question, variable or sequence.
class Link < ActiveRecord::Base
  belongs_to :topic
  belongs_to :target, polymorphic: true
end
