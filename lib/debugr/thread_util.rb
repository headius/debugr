module Debugr
  module ThreadUtil
    def on_thread(vm, id)
      id = id.to_i
      found = false
      vm.threads.each do |thread|
        next unless thread.unique_id == id
        found = true
        yield thread
      end
      puts "Thread ID not found: #{id}" unless found
    end
    module_function :on_thread
  end
end