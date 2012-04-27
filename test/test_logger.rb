require "./" + File.dirname(__FILE__) + "/../lib/swak"

log = Swak::Logger.new
log.puts "What's up?"
log.progname = "myprog"
log.puts "The sky."
log.indent_str = "*"
log.indent
log.puts "Blah"
log.unindent
log.puts "bar"
log.indent(4)
log.puts "Blah"
log.unindent
log.puts "bar"
log.unindent(2)
log.puts "bar"
log.unindent
log.puts "bar"
log.unindent
log.puts "bar"
