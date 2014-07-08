class FunctionSignature

  signature = nil
  def initialize(signature)
    @signature = signature
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
  def return_value
    temp = @signature.lstrip.split
    if temp[1].start_with?"*"
      result = temp[0].concat("*")
    end
    return result
  end

  ####################################################################
  # Returns true if the function has a return value. false otherwise 
  ####################################################################
  def has_return_value?
    ret_val = return_value
    if ret_val.match("void")
      return false
    else return true
    end
  end
  
  ####################################################################
  # returns number of parameters in a function
  ####################################################################
  
  def parameter_count
    ret_val = 0
    result = parse
    unless result.last.eql?("void")
    ret_val = result.length - 2
    end
    return ret_val
  end
end