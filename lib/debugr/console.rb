module Debugr
  class Console
    java_import com.sun.jdi.Bootstrap
  
    def initialize(argv)
      @vm = VM.new(argv)
    end
    
    def go
      while line = Readline.readline("> ")
        begin
          _, cmd, args = /^([a-z?]+) ?(.*)/.match(line).to_a
          Commands.execute(@vm, cmd, args)
        rescue SystemExit
          raise
        rescue Exception => e
          puts e.message
          p e.backtrace if $VERBOSE
        end
      end
    end
  end
end