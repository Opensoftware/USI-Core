class Annual < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :academy_units
  has_many :enrollment_semesters, :dependent => :destroy

  def to_s
    name
  end


end
