class Course < ActiveRecord::Base

    translates :name

    if defined? Diamond
        has_many :course_theses, :class_name => "Diamond::CourseThesis"
        has_many :theses, :dependent => :nullify, :class_name => "Diamond::Thesis"
    end

end
