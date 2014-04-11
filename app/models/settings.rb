class Settings < ActiveRecord::Base

    belongs_to :annual, :foreign_key => :current_annual_id

end
