class Variable < ActiveRecord::Base
  belongs_to :instrument
  has_many :questions, :through => :map, :source => :mapable, source_type: "Question"
  has_many :map, :dependent => :destroy
  has_many :src, -> {where mapable_type: 'Variable'}, :class_name => 'Map', :foreign_key => 'mapable_id', :dependent => :destroy
  has_many :src_variables, :through => :map, :source => :mapable, source_type: "Variable"
  has_many :out_variables, :through => :src, :source => :variable
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
    if var_type == 'Normal'
      if questions.count > 0
        return questions.first.get_topic
      else
        return nil
      end
    else
      if src_variables.count > 0 
        return src_variables.first.get_topic
      else
        return nil
      end
    end
  end
end
