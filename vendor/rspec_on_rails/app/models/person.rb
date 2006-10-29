class Person < ActiveRecord::Base
  has_many :animals
  validates_presence_of :name
end
