module ActiveRecord
  class Base

    def self.records
      find(:all)
    end

  end
end
