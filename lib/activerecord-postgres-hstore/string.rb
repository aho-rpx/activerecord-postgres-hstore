class String

  # If the value os a column is already a String and it calls to_hstore, it
  # just returns self. Validation occurs afterwards.
  def to_hstore
    self
  end

  # Validates the hstore format. Valid formats are:
  # * An empty string
  # * A string like %("foo"=>"bar"). I'll call it a "double quoted hstore format".
  # * A string like %(foo=>bar). Postgres doesn't emit this but it does accept it as input, we should accept any input Postgres does

  def valid_hstore?
    pair = hstore_pair
    !!match(/^\s*(#{pair}\s*(,\s*#{pair})*)?\s*$/)
  end

  # Creates a hash from a valid double quoted hstore format, 'cause this is the format
  # that postgresql spits out.
  def from_hstore        
    token_pairs = (scan(hstore_pair)).map { |k,v| [k,v =~ /^NULL$/i ? nil : v] }
    token_pairs = token_pairs.map { |k,v|
      [k,v].map { |t| 
        case t
        when nil then t
        when /^"(.*)"$/ then $1.gsub(/\\(.)/, '\1')
        else t.gsub(/\\(.)/, '\1')
        end
      }
    }
    
    return appropriate_format token_pairs
  end

  private
  
  # correctly return an array if all values are nil
  def appropriate_format token_pairs
    if token_pairs.collect(&:last).compact.empty?
      return token_pairs.flatten.compact
    else
      return Hash[ token_pairs ]
    end
  end

  def hstore_pair
    quoted_string = /"[^"\\]*(?:\\.[^"\\]*)*"/
    unquoted_string = /[^\s=,][^\s=,\\]*(?:\\.[^\s=,\\]*|=[^,>])*/
    string = /(#{quoted_string}|#{unquoted_string})/
    /#{string}\s*=>\s*#{string}/
  end
end
