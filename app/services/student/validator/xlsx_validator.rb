require 'creek'

class Student::Validator::XlsxValidator

  include Interactor

  def call

    xls = Creek::Book.new(context.file_absolute_path, check_file_extension: false)
    sheet = xls.sheets[0]
    unless sheet.rows.first.length >= 10
      context.fail!(message: "error.xls_file_too_few_columns")
    end
    rows = sheet.rows.to_a.drop(1)
    rows.delete_if {|r| r.empty?}
    rows.each_with_index do |row, idx|
      # Expect column C to have an e-mail address.
      # Expect column D to have an integer (student index number)
      unless row["C#{idx+2}"] =~ /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ &&
          row["E#{idx+2}"].to_i != 0
        context.fail!(message: "error.xls_file_invalid_row",
                      :row_data => row.values.join(", "),
                      :row_number => idx+2)
      end
    end

  end

end
