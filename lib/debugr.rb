require 'debugr/jdi'
require 'readline'

class Debugr
  java_import com.sun.jdi.Bootstrap

  def init(argv)
    vmm = Bootstrap.virtual_machine_manager
    connector = vmm.default_connector
    args = connector.default_arguments

    #args.each do |name, arg|
    #  puts arg.name
    #  puts arg.description
    #  puts
    #end
    args['options'].value = "-cp #{ENV_JAVA['jruby.home'] + '/lib/jruby.jar'}"
    args['main'].value = "org.jruby.Main " + argv.join(' ')
    p args['main'].value

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

  def console
    while line = Readline.readline("> ")
      begin
        case line
          when "resume"
            puts "resuming VM"
            resume
          when "threads"
            @virtual_machine.all_threads.each do |thread|
              puts " #{thread.unique_id}:  #{thread.name} = #{JDI::ThreadReference::Statuses[thread.status]}"
            end
          when /^stack (\d+)/
            _on_thread($1) do |thread|
              suspended = thread.suspended?
              thread.suspend unless suspended
              thread.frames.each do |frame|
                puts frame.location
              end
              thread.resume unless suspended
            end
          when /^resume (\d+)/
            _on_thread($1) {|thread| thread.resume}
          when /^suspend (\d+)/
            _on_thread($1) {|thread| thread.suspend}
          when "quit", "q"
            @virtual_machine.exit(0) rescue nil
            exit
          when "help", "?"
            puts <<HELP
Available commands:

resume\tResume execution
suspend\tSuspend execution
resume <id>\tResume an individual thread
suspend <id>\tSuspend an individual thread
threads\tList running threads
stack <id>\tDump stack for a given thread
quit\tTerminate the VM and exit debugger
help\tDisplay this message
HELP
          else
            puts "Unknown command: " + line
        end
      rescue SystemExit
        raise
      rescue Exception => e
        puts e.message
        p e.backtrace if $VERBOSE
      end
    end
  end

  def _on_thread(id)
    id = id.to_i
    found = false
    @virtual_machine.all_threads.each do |thread|
      next unless thread.unique_id == id
      found = true
      yield thread
    end
    puts "Thread ID not found: #{id}" unless found
  end

  def resume
    @virtual_machine.resume
  end
end