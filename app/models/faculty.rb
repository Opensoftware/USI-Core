class Faculty < AcademyUnit

    belongs_to :university, :class_name => "AcademyUnit",
               :foreign_key => :overriding_id, :touch => true
    has_many :courses, :foreign_key => :academy_unit_id, :dependent => :destroy
    belongs_to :annual

    def <=>(other)
        self.short_name <=> other.short_name
    end
end
