class Hash

  # Generates an hstore string format. This is the format used
  # to insert or update stuff in the database.
  def to_hstore
    return "" if empty?

    map { |idx, val| 
      iv = [idx,val].map { |_| 
        e = _.to_s.gsub(/"/, '\"')
        if _.nil?
          'NULL'
        elsif e =~ /[,\s=>]/ || e.blank?
          '"%s"' % e
        else
          e
        end
      }

      "%s=>%s" % iv
    } * ","
  end

end
