class Question < ActiveRecord::Base
  belongs_to :instrument
  has_many :variables, :through => :map, :as => :mapable
  has_many :map, as: :mapable

  validates :qc, :uniqueness => {:scope => :instrument_id}

  def get_comma_separated_variables
    var_names = []
    variables.each do |variable|
      var_names.push(variable.name)
    end
    return var_names.join(',')
  end
end
