class AnnualStudy < ActiveRecord::Base

  belongs_to :annual
  belongs_to :studies

end
