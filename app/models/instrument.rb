class Instrument < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :variables, dependent: :destroy
  accepts_nested_attributes_for :questions
  accepts_nested_attributes_for :variables
end
