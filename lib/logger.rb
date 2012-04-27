require 'logger'

module Swak
  class Logger
    attr_accessor :num_indents, :progname, :logger, :indent_str

    def initialize(progname=nil, fout=STDERR)
      @num_indents = 1
      @indent_str = "  "
      @progname = progname
      @logger = ::Logger.new(fout)

      @logger.datetime_format = "%m-%d %H:%M:%S"
      @logger.formatter = proc { |severity, datetime, progname, msg|
        prog_str = progname ? "[#{progname}] " : ""
        "#{prog_str}#{datetime.strftime(@logger.datetime_format)}#{@indent_str * @num_indents}#{msg}\n"
      }
    end

    def indent(levels=1)
      @num_indents += levels
      @num_indents = [@num_indents, 1].max
    end

    def unindent(levels=1)
      @num_indents -= levels
      @num_indents = [@num_indents, 1].max
    end

    def puts(msg)
      @logger.info(@progname) {msg}
    end
  end
end
