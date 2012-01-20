module RubyCraft
  class ConfigAdapter
    @config
    def initialize
      throw RubyCraft::ConfigAdapterError.new()
    end
    def get val
      throw RubyCraft::ConfigAdapterError.new()
    end
    def set val
      throw RubyCraft::ConfigAdapterError.new()
    end
    def save
      throw RubyCraft::ConfigAdapterError.new()
    end
    def reload
      throw RubyCraft::ConfigAdapterError.new()
    end
  end
end
