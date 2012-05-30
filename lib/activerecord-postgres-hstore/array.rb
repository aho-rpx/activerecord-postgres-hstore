class Array

  def to_hstore
    return "" if empty?
    map { |val| 
      iv = [val].map { |_| 
        e = _.to_s.gsub(/"/, '\"')
        if _.nil?
          'NULL'
        elsif e =~ /[,\s=>]/ || e.blank?
          '"%s"' % e
        else
          e
        end
      }

      "%s=>NULL" % iv
    } * ","
  end
  
  # If the method from_hstore is called in a Hash, it just returns self.
  def from_hstore
    self
  end
  
end