require_relative 'querier'
require_relative 'configuration'
require_relative 'assertionerror'

##################################################################################
# Class that provides APIs to read various test parameters from excel spreadsheet
# in a specified format
##################################################################################
class SpreadSheetReader

  @querier = nil
  @entire_test_matrix = nil

  # arrays of headers
  @kind = []
  @datatypes =[]
  @names= []
  #############################################################################################
  # Class constructor - Initializes querier, which is responsible for querying the spreadsheet
  # and pre-processes spreadsheet to populate a bunch of arrays that contain metadata about
  # test matrix
  #############################################################################################
  def initialize path
    unless path.end_with?(";")
      @querier = Querier.new(path.concat(";"))
    end

    #read entire test matrix
    get_entire_test_matrix

    # read "Kind" column description
    get_kinds_description

    # get 'Datatypes' column description
    get_datatypes_description

    # get "Name" column description
    get_names_description

    # sanity check - 'Kind' and 'Datatype' must map one to one
    assert{@kind.length == @datatypes.length}
    assert {@kind.length == @names.length}

  end

  ##################################################################################
  # Returns the number of documented test cases in the spreadsheet
  ##################################################################################
  def get_test_case_count
    return @entire_test_matrix[0].length
  end

  ##################################################################################
  # Reads the function signature from the spreadheet
  ##################################################################################
  def get_function_signature
    query = "SELECT VALUE from [FUNCTION_METADATA$]"
    @querier.open_connection()
    data =  @querier.get(query)
    @querier.close_connection()
    return data.flatten[0]
  end

  ##################################################################################
  # Returns an array of global datatypes from spreadsheet
  ##################################################################################
  def get_global_datatypes
    globals = []
    @kind.each_index{|index|
      if @kind[index].match(Configuration.globals_tag)
        globals.push(@datatypes[index])
      end
    }

    return globals
  end

  ##################################################################################
  # Returns a hashmap of global names as keys and the array of values they take as 
  # value
  ##################################################################################
  def get_global_values
    globals_hash = Hash.new
    create_hash(globals_hash, Configuration.globals_tag)
    return globals_hash
  end

  ##################################################################################
  # Returns an array of function parameter datatypes from spreadsheet
  ##################################################################################
  def get_parameter_datatypes
    params = []
    @kind.each_index{|index|
      if @kind[index].match(Configuration.parameters_tag)
        params.push(@datatypes[index])
      end
    }

    return params
  end

  #####################################################################################
  # Returns a hashmap of parameter names as keys and the array of values they take as 
  # value
  #####################################################################################
  def get_parameters_values
    params_hash = Hash.new
    create_hash(params_hash, Configuration.parameters_tag)
    return params_hash
  end

  #######################################################################################
  # Return temp_datatypes array with datatypes of declared temp variables -
  # These will be used to substitute hard-coded test values inside the test matrix,
  # if required. e.g. if the test value needs to be a pointer to some value.
  #######################################################################################
  def get_temp_test_var_datatypes

    query = "SELECT DATATYPE FROM [TEMP_TEST_VAR$]"
    return get_temp_var_data(query)
  end

  ########################################################################################
  # Returns an array of temp variable names
  ########################################################################################
  def get_temp_test_var_names

    query = "SELECT NAME FROM [TEMP_TEST_VAR$]"
    return get_temp_var_data(query)
  end

  ########################################################################################
  # Returns an array of temp variable values
  ########################################################################################
  def get_temp_test_var_values
    
    query = "SELECT VALUE FROM [TEMP_TEST_VAR$]"
    return get_temp_var_data(query)
    
  end

  ##################################################################################
  # Returns an array of expected return values with array index as test case ID
  ##################################################################################
  def get_expected_return_datatype
    retval = []
    @kind.each_index{|index|
      if @kind[index].match(Configuration.expected_returnvalue_tag)
        retval.push(@datatypes[index])
      end
    }

    return retval
  end

  ##################################################################################
  # Returns an array of expected return values with array index as test case ID
  ##################################################################################
  def get_expected_return_values
    retval_hash = Hash.new
    retvals = []

    create_hash(retval_hash, Configuration.expected_returnvalue_tag)
    retvals = retval_hash.flatten
    retvals.slice!(0)
    retvals.flatten!
    return retvals
  end

  #######################################################################################
  # Populates @kind array with all column names in the table -
  # These will be used to identify type of data - i.e. parameter, global or return value
  #######################################################################################
  def get_kinds_description
    query = "SELECT * FROM [TEST_MATRIX$] WHERE KEY=\'Kind\'"
    @querier.open_connection()
    @kind =  @querier.get(query)
    @querier.close_connection()

    @kind.delete_at(0)
    @kind.flatten!
    @kind.compact!

  end

  #######################################################################################
  # Populates @datatypes array with all column names in the table -
  # These will be used to identify type of data - i.e. parameter, global or return value
  #######################################################################################
  def get_datatypes_description
    query = "SELECT * FROM [TEST_MATRIX$] WHERE KEY=\'Datatypes\'"
    @querier.open_connection()
    @datatypes =  @querier.get(query)
    @querier.close_connection()

    @datatypes.delete_at(0)
    @datatypes.flatten!
    @datatypes.compact!
    @datatypes.each{|element|
      element.gsub!(" ", "")
    }
  end

  #######################################################################################
  # Populates @names array with names of test variables -
  # These will be used as keys in the hashmap
  #######################################################################################
  def get_names_description

    query = "SELECT * FROM [TEST_MATRIX$] WHERE KEY=\'Name\'"

    @querier.open_connection()
    @names =  @querier.get(query)
    @querier.close_connection()
    @names.delete_at(0)
    @names.flatten!
    @names.compact!
    # @names.each{|element|
    #   element.gsub!(" ", "")
    # }
  end

  ############################################################################
  # Populates the entire test matrix
  ############################################################################
  def get_entire_test_matrix
    query = "SELECT * from [TEST_MATRIX$]"

    begin
      @querier.open_connection()
      @entire_test_matrix =  @querier.get(query)
      @querier.close_connection()

      #drop unnecessary rows and columns from the matrix
      trim(@entire_test_matrix, 3, 1)
    rescue
      puts "could not populate test matrix in get_entire_test_matrix()"
    end
  end

  ############################################################################
  # trims the raw test matrix to retain only the test data
  ############################################################################
  def trim(matrix, lastRowIndexToTrim, lastColumnIndexToTrim)
    #safest way is to go through each subarray and delete the required number of
    #elements from each subarray (in this case - the number of header rows)
    matrix.each{|subarray|
      subarray.slice!(0..lastRowIndexToTrim-1)
    }
    #then drop the serial number column as well
    matrix.slice!(0..lastColumnIndexToTrim-1)
  end

  ###############################################################################
  # generic method to populate hashmap for the given "kind"
  ###############################################################################
  def create_hash(map, tag)
    # iterate over "Kinds" and find the global datatypes
    @kind.each_index{ |index|

      # when a global column is found, hash the corresponding data array against the name of variable
      if @kind[index].eql?(tag)
        key = @names[index] == nil ? "key"+index.to_s : @names[index].to_s
        map.store(@names[index], @entire_test_matrix[index])
      end

    }
  end

  #
  #
  #
  def get_temp_var_data(query)

    temp = []

    @querier.open_connection()
    temp =  @querier.get(query)
    @querier.close_connection()

    temp.flatten!
    temp.compact!
    temp.each{|element|
      element.gsub!(" ", "")
    }
    return temp
  end

  ############################################################################
  # Private instance members
  ############################################################################
  private :get_kinds_description
  private :get_datatypes_description
  private :get_entire_test_matrix
  private :get_names_description
  private :trim
  private :create_hash
  private :get_temp_var_data

end
