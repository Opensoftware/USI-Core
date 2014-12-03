module Student::Persistence

  class XlsxRow < Row

    def get(key)
      row["#{mappings[key]}#{idx+2}"]
    end

  end

end
