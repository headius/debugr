module Debugr::Commands
  class Error
    def execute(vm, args)
      puts "Unknown command"
    end
  end
end