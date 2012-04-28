require 'logger'

module Swak
  class Logger
    attr_accessor :num_indents, :progname, :logger, :indent_str, :do_datetime

    def initialize(progname=nil, fout=STDERR)
      @num_indents = 0
      @do_datetime = true
      @indent_str = "  "
      @progname = progname
      @logger = ::Logger.new(fout)

      @logger.datetime_format = "%m-%d %H:%M:%S"
      @logger.formatter = proc { |severity, datetime, progname, msg|
        prog_str = progname && progname.length > 0 ? "[#{progname}]" : ""
        has_prog = prog_str.length > 0

        date_str = @do_datetime ? datetime.strftime(@logger.datetime_format) : ""
        date_str = "#{indent_str}#{date_str}" if date_str.length > 0  && has_prog
        has_date = date_str.length > 0

        has_prefix = has_prog || has_date

        indent_str = @indent_str * (@num_indents + (has_prefix ? 1 : 0))

        "#{prog_str}#{date_str}#{indent_str}#{msg}\n"
      }
    end

    def indent(levels=1)
      @num_indents += levels
      @num_indents = [@num_indents, 0].max
      nil
    end

    def unindent(levels=1)
      @num_indents -= levels
      @num_indents = [@num_indents, 0].max
      nil
    end

    def puts(*messages)
      messages = [""] if messages.nil? || messages.size == 0

      for msg in messages
        @logger.info(@progname) {msg}
      end

      nil
    end

    # Usage: 
    #   section("== My Section ==") { some_code }
    # or 
    #   section("== My Section ==")
    #   endsect
    def section(msg)
      puts(msg)
      indent
      if block_given?
        yield
        unindent
      end
      nil
    end

    def endsect
      unindent
      nil
    end
  end
end
