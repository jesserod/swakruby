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
log.puts "bar", 'baz', 'bbbbb'
log.puts

log.indent_str = "  "
log.puts
log.puts
log.section "Section:manual"
log.puts "stuff inside"
log.puts
log.puts "xx"
log.endsect
log.section("Section:Auto") do
  log.puts "stuff inside";
  log.puts;
  log.puts "yy";
end

log.puts "zzz"

log.do_datetime = false
log.puts "without DT"
log.do_datetime = true
log.puts "with DT"

log.progname = ""
log.do_datetime = false
log.puts "noprog, without DT"
log.indent
log.puts "indented"
log.do_datetime = true
log.puts "noprog, with DT"
