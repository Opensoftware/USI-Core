module Student::Persistence

  class Row

    attr_reader :row, :idx, :mappings

    def initialize(row, idx, mappings)
      @row = row
      @idx = idx
      @mappings = mappings
    end

  end

end
