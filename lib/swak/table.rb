module Swak
  module Table
    class SmartRow
      attr_reader :header, :fields, :colmap

      def initialize(header, fields)
        if header.size != fields.size
          raise "Header and field size mismatch in SmartRow.new #{header.inspect} vs #{fields.inspect}"
        end

        @header = header
        @fields = fields
        @colmap = {}
        header.each_with_index {|fieldname, i| @colmap[fieldname] = i}
        if @colmap.size != @header.size
          raise "Duplicate field names not allowed in SmartRow header"
        end
      end

      def [](*args)
        if args.size == 1 && args[0].is_a?(String)
          @fields[@colmap[args[0]]]
        else
          @fields[*args]
        end
      end

      def []=(*args)
        if args.size == 2 && args[0].is_a?(String)
          @fields[@colmap[args[0]]] = args[-1]
        else
          @fields.[]=(*args)
        end
      end

      def method_missing(sym, *args, &block)
        @fields.send(sym, *args, &block)
      end
    end


    def Table.read(io_or_fn, opts={:has_header => false, :type => String, :delim => "\t", :smart => false})
      if io_or_fn.is_a?(String)
        io = File.new(io_or_fn)
      else
        io = io_or_fn
      end
      if opts[:has_header] || opts[:smart]
        header = io.gets.chomp 
        opts[:header] = header
        header_as_fields = header.split(delim)
        if header_as_fields.size > 0 && header_as_fields[0][0] == '#'
          header_as_fields[0][0] = ""
        end
      end
      
      table = []
      delim = opts[:delim] || "\t"

      case opts[:type].to_s
      when "Integer"
        ele_proc = Proc.new{|ele| ele.to_i_strict}
      when "Float"
        ele_proc = Proc.new{|ele| ele.to_f_strict}
      else
        ele_proc = Proc.new{|ele| ele} # By default, don't format
      end

      if opts[:smart]
        row_proc = Proc.new{|row| SmartRow.new(header_as_fields, row) }
      else
        row_proc = Proc.new{|row| row}
      end

      for line in io
        line.chomp!
        f = line.split(delim)
        table << row_proc.call(f.map(&ele_proc))
      end

      return table
    end

    def Table.write(table, io_or_fn, opts={:header => nil, :fmt => nil, :delim => "\t"})
      raise "Illegal fmt in Swak::Table.write: #{opts.inspect}" if !opts[:fmt].nil? && !opts[:fmt].is_a?(String)

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
      raise "Error in Swak::Table.transpose(): Cannot transpose a SmartRow table (yet)" if table.size > 0 && table[0].is_a?(SmartRow)
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

    def Table.column(table, col)
      table.map {|row| row[col]}
    end
  end
end
