module Linking
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
