module Debugr::Commands
  class Quit
    def execute(vm, args)
      vm.exit(0) rescue nil
      exit
    end
  end
end
