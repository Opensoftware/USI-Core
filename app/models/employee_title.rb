class EmployeeTitle < ActiveRecord::Base
    has_many :employees

    validates_presence_of :name

    def to_s
        name
    end
end
