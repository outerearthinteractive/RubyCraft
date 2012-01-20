module RubyCraft
  class ConfigAdapter
    @config
    def initialize
      raise RubyCraft::ConfigAdapterError.new()
    end
    def get val
      raise RubyCraft::ConfigAdapterError.new()
    end
    def set val
      raise RubyCraft::ConfigAdapterError.new()
    end
    def save
      raise RubyCraft::ConfigAdapterError.new()
    end
    def reload
      raise RubyCraft::ConfigAdapterError.new()
    end
  end
end
