module Debugr::Commands
  class Resume
    include Debugr::ThreadUtil
    
    def execute(vm, args)
      if args && !args.empty?
        on_thread(vm, args) {|thread| thread.resume}
      else
        puts "resuming VM"
        vm.resume
      end
    end
  end
end
