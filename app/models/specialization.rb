class Specialization < ActiveRecord::Base

  translates :name

  belongs_to :course
end
