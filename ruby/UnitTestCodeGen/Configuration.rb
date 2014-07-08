class Configuration
  @@globals_tag = "<global>"
  @@parameters_tag = "<argument>"
  @@returnvalue_tag = "<expected return value>"
  @@max_test_cases = 1000
  
  def self.globals_tag
    @@globals_tag
  end

  def self.parameters_tag
    @@parameters_tag
  end

  def self.returnvalue_tag
    @@returnvalue_tag
  end

  def self.max_test_cases
    @@max_test_cases
  end

end

