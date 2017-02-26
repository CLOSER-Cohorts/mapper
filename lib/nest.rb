class Nest
    def self.find(obj)
      index = Rails.cache.read('tn_index_' + obj.class.name + obj.id.to_s)
      if index.nil?
        return
      end
      #Nest.new Rails.cache.read index
      Rails.cache.read index
    end
    
    def self.get(obj)
      nest = self.find obj
      if nest.nil?
        nest = self.new obj
      end
      nest
    end
	
	def initialize(obj=nil)
	  if not obj.nil?
	    if obj.is_a?(Hash)
	      @members = obj[:members]
	      @topic = obj[:topic]
	      @fixed_points = obj[:fixed_points]
	    else
	      build obj
	    end
	  end
	end
	
	def rebuild(obj)
	  @members = []
	  @fixed_points = []
	  @topic = nil
	  build obj
	end
  
	def build(obj, cache=true)
	  @members ||= []
	  @fixed_points ||= []
	  to_do = [obj]
	  until to_do.empty?
	    current = to_do.pop
	    if @members.include? current then next end
	    @members << current
	      
	    to_do += current.get_relations.reject{ |x| @members.include? x }
	      
	    if not current.topic.nil?
	      @fixed_points << (@members.length - 1)
	    end
	    if current.class.name == 'Variable'
	      if @id.nil? || @id > current.id
	        @id = current.id
	      end
	    end
	  end
	  if cache then save end
	end
	
	def evaluate
	  good = true
	  @fixed_points.each do |fp|
	    good &&= self.compare_topic @members[fp].topic
	  end
	  good
	end
	
	def compare_topic(c_topic)
	  if @topic.nil?
	    @topic = c_topic
	  end
	  @topic == c_topic
	end
	
	def id
	  if @id.nil?
	    @members.each do |m|
	      if m.class.name == 'Variable'
	        if @id.nil? || @id > m.id
	          @id = m.id
	        end
	      end
	    end
	  end
	  @id
	end
	
	def members
	  @members
	end
	
	def topic
	  @topic
	end
	
	def fixed_points
	  @members.values_at *@fixed_points
	end
	
	def topic=(new_topic)
	  if @fixed_points.empty?
	    @topic = new_topic
	  else
	    #throw an error
	  end
	end
	
	#Saves nest to the cache
	#
	#This function not only saves the nest to the cache, but also
	#creates all of the indexes within the cache to speed up retrieval.
	def save
	  index = 'tn_' + @id.to_s
	  @members.each do |m|
	    Rails.cache.write 'tn_index_' + m.class.name + m.id.to_s, index
	  end
	  #Rails.cache.write index, {members: @members, topic: @topic, fixed_points: @fixed_points}
	  Rails.cache.write index, self
	end
	
	def ==(other_nest)
	  @id == other_nest.id
	end
end