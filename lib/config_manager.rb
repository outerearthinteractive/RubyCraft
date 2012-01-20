module RubyCraft
  class YAMLConfig < ConfigAdapter
  @file
  def initialize(file)
    @file = file
    @cfg = YAML.load(file)
  end
  def save(file)
    YAML.dump(@file)
  end
  def close
    @file.close
  end
end
