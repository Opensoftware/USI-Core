class Employee < ActiveRecord::Base

  include PgSearch
  pg_search_scope :search_by_full_name, :against => [:surname, :name],
    :using => {
    :tsearch => {:prefix => true}
  }

  belongs_to :academy_unit, :class_name => "AcademyUnit",
    :foreign_key => :academy_unit_id
  belongs_to :department, :class_name => "Department",
    :foreign_key => :department_id
  belongs_to :employee_title
  belongs_to :building
  has_one :user, :as => :verifable,
    :class_name => "User"
  accepts_nested_attributes_for :user, :allow_destroy => true

  def <=>(other)
    surname <=> other.surname
  end

  def self.search(query)
    if query.present?
      search_by_full_name(query)
    else
      self
    end
  end

  def full_name
    employee_title.try(:name).to_s + " " + surname + " " + name
  end

  def surname_name
    "#{surname} #{name}"
  end

  def surname_name_title
    "#{surname} #{name}" + (employee_title.present? ? ", #{employee_title.name}" : "")
  end

  if defined?(Diamond)
    after_save :touch_enrollments

    has_many :theses, :class_name => "Diamond::Thesis", :dependent => :nullify, :foreign_key => :supervisor_id
    has_many :thesis_enrollments, :through => :theses, :source => :enrollments

    scope :having_theses, -> { select("DISTINCT #{self.table_name}.*").joins(:theses) }

    def having_any_theses?
      Employee.having_theses.where("#{self.class.table_name}.id" => self.id).any?
    end

    def thesis_limit_not_exceeded?(annual)
      theses.assigned.by_annual(annual).count < department.settings_for_annual(annual).max_theses_count
    end

    def deny_remaining_theses!(annual)
      theses.by_annual(annual).not_assigned.each do |thesis|
        thesis.deny! if thesis.can_deny?
        thesis.enrollments.each do |enrollment|
          enrollment.reject! if enrollment.can_reject?
        end
      end
    end

    def touch_enrollments
      thesis_enrollments.update_all(updated_at: Time.now)
    end
  end

end
