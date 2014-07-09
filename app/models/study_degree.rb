class StudyDegree < ActiveRecord::Base

  FIRST_DEGREE_CODE = "1"
  SECOND_DEGREE_CODE = "2"

  translates :name, :short_name
  globalize_accessors :locales => I18n.available_locales

  def to_s
    name
  end

  %w(first second).each do |prefix|
    define_method "#{prefix}_degree?" do
      code == StudyDegree.const_get("#{prefix.upcase}_DEGREE_CODE")
    end
  end

end
