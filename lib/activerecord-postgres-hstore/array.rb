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
    
end