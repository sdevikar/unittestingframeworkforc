###############################################################
# A class dedicated to parsing a C language function signature
###############################################################
class FunctionSignature

  @signature = nil
  @result = nil
  
  def initialize(signature)
    @signature = signature
    @result = parse()
  end

  ##################################################
  # parses signature to return an array as follows
  # result[0]     => return value
  # result[1]     => method name
  # result[2..n]  => method arguments
  ##################################################
  def parse
    temp_signature = String.new(@signature)
    temp = []
    result = []
    unless temp_signature.empty?

      temp_signature.lstrip!           # remove leading whitespaces
      temp_signature.gsub!(/\s+/, ' ')  # remove consecutive whitespaces
      temp = temp_signature.split      # split function signature into an array

      #extract return value
      result[0] = temp[0]
      if temp[1].start_with?"*"
        result[0] = result[0].concat "*"
        temp[1].gsub!("*","")        #remove the * sign from signature
      end

      #extract function name
      temp = temp[1].split('(')
      result[1] = temp[0]

      #extract arguments enclosed in () 
      # NOTE: More work required to parse arguments containing argument names as well
      startIndex = temp_signature.index('(')+1
      endIndex = temp_signature.index(')')-1
      temp = temp_signature[startIndex..endIndex].split(',')
      temp.compact!
      temp.each{|this_element|
        this_element.rstrip!
        this_element.lstrip!
        result.push(this_element)
      }

    end
    return result
  end

  ####################################################################
  # Returns the return value from the function signature
  ####################################################################
  def return_type
    return @result[0]
  end

  ####################################################################
  # Returns true if the function returns void. false otherwise
  ####################################################################
  def returns_void?
    ret_val = return_type()
    
    if ret_val.downcase.match("void")
      return true
    else return false
    end
  end

  ####################################################################
  # returns number of parameters declared in function signature
  ####################################################################
  def parameter_count
    return @result.length
  end

  #####################################################################
  # Returns an array of parameters declared in the function signature
  #####################################################################
  def parameters
    params = nil
    count = parameter_count
    if count > 0
      params =  @result[2..count-1]
    end
    return params
  end
  
  ####################################################################
  # Returns the name of the function in function signature
  ####################################################################
  def name
    return @result[1]
  end

  private :parse
end