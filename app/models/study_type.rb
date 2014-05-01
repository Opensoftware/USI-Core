class StudyType < ActiveRecord::Base

  translates :name, :short_name
  globalize_accessors :locales => I18n.available_locales

end
