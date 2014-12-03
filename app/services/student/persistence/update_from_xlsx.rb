require 'creek'

module Student::Persistence

  class UpdateFromXlsx < UpdateEngine

    include Interactor

    MAPPINGS = {
      :course_id => "F",
      :study_type_id => "I",
      :study_degree_id => "H",
      :specialty_id => "G",
      :surname => "A",
      :name => "B",
      :average_grade => "K",
      :passed_ects => "L",
      :semester_number => "J",
      :index_number => "E",
      :email => "C",
      :id_number => "D"
    }

    def call
      @xls = Creek::Book.new(context.file_absolute_path,
                             check_file_extension: false)
      @sheet = xls.sheets[0]

      perform_update
    end

    private

    def build_row(row, idx)
      XlsxRow.new(row, idx, MAPPINGS)
    end

    def loop
      rows = sheet.rows.to_a.drop(1)
      rows.delete_if {|r| r.empty?}
      rows.each_with_index do |row, idx|
        yield(row, idx)
      end
    end
  end
end
