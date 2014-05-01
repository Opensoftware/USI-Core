class StudyDegree < ActiveRecord::Base

  translates :name, :short_name
  globalize_accessors :locales => I18n.available_locales

  def to_s
    name
  end

end
