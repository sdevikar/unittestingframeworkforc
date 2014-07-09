require_relative 'functionsignature'
require_relative 'spreadsheetreader'


my_function1 = "void fc_xmcyclic(int,int,int)"
my_function2 = "BYTE fc_xmcyclic(void)"
my_function3 = "BYTE* fc_xmcyclic(void)"
my_function4 = "BYTE *fc_xmcyclic(void)"
my_function5 = "BYTE *fc_xmcyclic(void *)"


signature = FunctionSignature.new(my_function5)

puts signature.return_type()

puts signature.returns_void?()

puts signature.parameter_count()

puts signature.parameters()

#puts parser.parse(my_function2)
#puts parser.parse(my_function3)
#puts parser.parse(my_function4)



#reader = SpreadSheetReader.new('C:\Users\sdevikar\Desktop\ruby script for autogenerating unit test code\Unit testing template.xls')

#puts reader.get_function_signature

#
#columns = reader.get_datatypes_description()
#
#puts "Entire matrix:"
#puts reader.get_entire_test_matrix()
#
#
#columns.each{|element| puts element}
#
#puts "Global types: "
#puts reader.get_global_datatypes()
#
#puts "Parameter types :"
#puts reader.get_parameter_datatypes()
#
#puts "Return value type:"
#puts reader.get_expected_retval_datatype()
#
#puts "Temporary datatypes:"
#puts reader.get_temp_test_var_datatypes()
#puts "Done!"
#
#puts "Names record:"
#puts reader.get_names_description()

=begin
puts "Global variable values:"
map =  reader.get_global_values()
map.each_key{|key| puts key+"==>"
  puts map[key]
}

puts "Argument values:"
map =  reader.get_parameters_values()
map.each_key{|key| puts key+"==>"
  puts map[key]
}

puts "Temporary test variable datatypes:"
puts reader.get_temp_test_var_datatypes().to_s

puts "Temporary test variable values:"
puts reader.get_temp_test_var_values().to_s

puts "Return values:"
puts reader.get_expected_return_values().to_s

puts "Number of test cases:"
puts reader.get_test_case_count()
=end