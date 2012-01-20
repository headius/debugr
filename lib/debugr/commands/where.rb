module Debugr::Commands
  class Where
    include Debugr::ThreadUtil
    
    def execute(vm, args)
      on_thread(vm, args) do |thread|
        suspended = thread.suspended?
        thread.suspend unless suspended
        thread.frames.each do |frame|
          puts frame.location
        end
        thread.resume unless suspended
      end
    end  
  end
end
