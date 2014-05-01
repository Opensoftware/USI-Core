class Semester < ActiveRecord::Base

  translates :name
  globalize_accessors :locales => I18n.available_locales

end
