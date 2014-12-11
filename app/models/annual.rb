class Annual < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :academy_units
  has_many :enrollment_semesters, :dependent => :destroy
  has_many :annual_semesters, dependent: :destroy
  has_many :semesters, through: :annual_semesters
  has_many :theses, class_name: "Diamond::Thesis"

  def to_s
    name
  end

  def self.newest
    order("id DESC").first
  end

end
