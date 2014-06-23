class Semester < ActiveRecord::Base

  translates :name
  globalize_accessors :locales => I18n.available_locales

  has_many :annual_semesters, dependent: :destroy
  has_many :annuals, through: :annual_semesters
  has_many :enrollment_semesters

end
