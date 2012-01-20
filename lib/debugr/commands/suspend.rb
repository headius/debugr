module Debugr::Commands
  class Suspend
    include Debugr::ThreadUtil
    
    def execute(vm, args)
      on_thread(vm, args) {|thread| thread.suspend}
    end
  end
end
