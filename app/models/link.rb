class Link < ActiveRecord::Base
  belongs_to :topic
  belongs_to :target, polymorphic: true
end
