require 'win32ole'

#
# Class to run raw sql style queries on excel spreadsheet
#
class Querier
  def initialize(message_database)
    #puts message_database
    @connection = WIN32OLE.new('ADODB.Connection')
    @conn_string =  'Provider=Microsoft.Jet.OLEDB.4.0;'
    @conn_string << 'Data Source='+message_database
    @conn_string << 'Extended Properties=Excel 8.0;'
  end

  def open_connection
    @connection.Open(@conn_string)
    @recordset = WIN32OLE.new('ADODB.Recordset')
    if @recordset !=nil
      #puts "Connection Successful"
    else
      puts "Cannot access the message database"
    end
    
  end

  def get(query)
    @recordset.Open(query, @connection)
    data = @recordset.GetRows
    return data
  end

  def close_connection
    @connection.close
  end

end