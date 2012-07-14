module Swak
  module Table
    def Table.read(io_or_fn, opts={:has_header => false, :type => String, :delim => "\t"})
      if io_or_fn.is_a?(String)
        io = File.new(io_or_fn)
      else
        io = io_or_fn
      end
      if opts[:has_header]
        header = io.gets 
        opts[:header] = header.chomp
      end
      
      table = []
      delim = opts[:delim] || "\t"

      if (opts[:type] == Integer)
        for line in io
          line.chomp!
          f = line.split(delim)
          table << f.map{|x| x.to_i_strict}
        end
      elsif (opts[:type] == Float)
        for line in io
          line.chomp!
          f = line.chomp.split(delim)
          table << f.map{|x| x.to_f_strict}
        end
      else # Assume String
        for line in io
          line.chomp!
          table << line.split(delim)
        end
      end

      return table
    end

    def Table.write(table, io_or_fn, opts={:header => nil, :fmt => nil, :delim => "\t"})
      raise "Illegal fmt in Swak::Table.write" if !opts[:fmt].nil? && !opts[:fmt].is_a?(String)

      delim = opts[:delim] || "\t"

      header = opts[:header]
      header = header.join(delim) if header.is_a?(Array) && header.size > 0

      if io_or_fn.is_a?(String)
        io = File.new(io_or_fn, "w")
      else
        io = io_or_fn
      end

      io.puts header if !header.nil?

      if opts[:fmt]
        fmt = opts[:fmt]
        for row in table
          io.puts row.map{|str| fmt % str }.join(delim)
        end
      else
        for row in table
          io.puts row.join(delim)
        end
      end

      io.close if io_or_fn.is_a?(String)
    end

    def Table.transpose(table)
      raise "Error in Swak::Table.transpose(): Cannot transpose nil table" if table.nil?
      return [] if table.size == 0

      num_rows = table.size
      num_cols = table[0].size

      out_mat = Array.new(num_cols)

      for row in table
        raise "Error in Swak::Table.transpose(): Doesn't support jagged table" if row.size != num_cols
      end

      c = 0
      while c < num_cols
        out_mat[c] = Array.new(num_rows)
        r = 0
        while r < num_rows
          out_mat[c][r] = table[r][c]
          r += 1
        end
        c += 1
      end

      return out_mat
    end
  end
end
