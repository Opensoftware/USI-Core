module Student::Persistence

  class XlsRow < Row

    def get(key)
      row[mappings[key]]
    end

  end

end
