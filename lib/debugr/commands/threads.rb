module Debugr::Commands
  class Threads
    def execute(vm, args)
      vm.threads.each do |thread|
        puts " #{thread.unique_id}:  #{thread.name} = #{JDI::ThreadReference::Statuses[thread.status]}"
      end
    end
  end
end
