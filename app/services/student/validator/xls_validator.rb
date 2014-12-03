require 'spreadsheet'

class Student::Validator::XlsValidator

  include Interactor

  def call

    xls = Spreadsheet.open(context.file_absolute_path)
    sheet = xls.worksheet(0)
    unless sheet.row(0).to_a.length >= 10
      context.fail!(message: "error.xls_file_too_few_columns")
    end

    sheet.each_with_index(1) do |row, idx|
      # Expect column C to have an e-mail address.
      # Expect column D to have an integer (student index number)
      unless row[2] =~ /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ &&
          row[4].to_i != 0
        context.fail!(message: "error.xls_file_invalid_row",
                      :row_data => row.join(", "),
                      :row_number => idx+2)
      end
    end

  end

end
