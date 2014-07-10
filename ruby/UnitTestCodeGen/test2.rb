require_relative 'scriptgenerator'

generator = ScriptGenerator.new("resources/Unit testing template.xls")

generator.generate_metadata
generator.generate_test_data
generator.generate_test_code