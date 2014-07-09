require_relative 'scriptgenerator'

generator = ScriptGenerator.new("resources/Unit testing template.xls")

#generator.generate_metadata
#generator.generate_test_data

#puts generator.get_initlized_test_data()

puts generator.get_params_as_struct_members