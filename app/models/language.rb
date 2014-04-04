class Language < ActiveRecord::Base

    translates :name, :fallbacks_for_empty_translations => true
    globalize_accessors :locales => I18n.available_locales

    def self.available_languages
        where(:code => I18n.available_locales)
    end
end
