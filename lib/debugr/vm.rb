module Debugr
  class VM
    java_import com.sun.jdi.Bootstrap
    
    def initialize(argv)
      vmm = Bootstrap.virtual_machine_manager
      connector = vmm.default_connector
      args = connector.default_arguments
      
      args['options'].value = "-cp #{ENV_JAVA['jruby.home'] + '/lib/jruby.jar'}"
      args['main'].value = "org.jruby.Main " + argv.join(' ')
      puts "Running #{args['main'].value}"
  
      @virtual_machine = connector.launch(args)
  
      # drive output streams
      Thread.abort_on_exception = true
      stdout = $stdout.to_outputstream
      Thread.new do
        stdout.write(@virtual_machine.process.input_stream.read)
      end
  
      stderr = $stderr.to_outputstream
      Thread.new do
        stderr.write(@virtual_machine.process.error_stream.read)
      end
    end
    
    def resume
      @virtual_machine.resume
    end
    
    def threads
      @virtual_machine.all_threads
    end
  end
end