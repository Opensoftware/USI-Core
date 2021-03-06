class Settings < ActiveRecord::Base

  translates :welcome_text

  belongs_to :annual, :foreign_key => :current_annual_id
  belongs_to :enrollment_semester, :foreign_key => :current_semester_id
  accepts_nested_attributes_for :enrollment_semester

  scope :pick_newest, -> { order("id DESC").first }

  def self.available_settings
    return @available_settings if defined?(@available_settings)
    begin
      @available_settings = YAML::load(File.open("#{Rails.root}/config/settings.yml"))
    rescue Errno::ENOENT => e
      @available_settings = {}
    end
  end

  self.available_settings.each do |key, v|
    define_singleton_method key do
      v
    end
  end
end
