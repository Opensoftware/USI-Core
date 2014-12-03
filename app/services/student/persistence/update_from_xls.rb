require 'spreadsheet'


module Student::Persistence

  class UpdateFromXls < UpdateEngine

    include Interactor

    MAPPINGS = {
      :course_id => 5,
      :study_type_id => 8,
      :study_degree_id => 7,
      :specialty_id => 6,
      :surname => 0,
      :name => 1,
      :average_grade => 10,
      :passed_ects => 11,
      :semester_number => 9,
      :index_number => 4,
      :email => 2,
      :id_number => 3
    }

    def call
      @xls = Spreadsheet.open(context.file_absolute_path)
      @sheet = xls.worksheet(0)

      perform_update
    end

    private

    def build_row(row, idx)
      XlsRow.new(row, idx, MAPPINGS)
    end

    def loop
      sheet.each_with_index(1) do |row, idx|
        yield(row, idx)
      end
    end
  end
end
