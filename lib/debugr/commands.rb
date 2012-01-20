module Debugr
  module Commands
    COMMANDS = [
      :print,
      :eval,
      :set,
      :dump,
      :locals,
      :classes,
      :class,
      :connectors,
      :methods,
      :fields,
      :threads,
      :thread,
      :suspend,
      :resume,
      :cont,
      :threadgroups,
      :threadgroup,
      :catch,
      :ignore,
      :step,
      :stepi,
      :next,
      :kill,
      :interrupt,
      :trace,
      :untrace,
      :where,
      :wherei,
      :up,
      :down,
      :load,
      :run,
      :memory,
      :gc,
      :stop,
      :clear,
      :watch,
      :unwatch,
      :list,
      :lines,
      :classpath,
      :use,
      :monitor,
      :unmonitor,
      :lock,
      :disablegc,
      :enablegc,
      :save,
      :bytecodes,
      :redefine,
      :pop,
      :reenter,
      :extension,
      :exclude,
      :read,
      :help,
      :version,
      :quit
    ]
    
    COMMAND_OBJECTS = {}
    COMMANDS.each do |cmd|
      require "debugr/commands/#{cmd}"
      COMMAND_OBJECTS[cmd] = const_get(:"#{cmd.to_s.capitalize}").new
    end
    
    require 'debugr/commands/error'
    ERROR_OBJ = Error.new
    
    def self.execute(vm, cmd, args)
      (COMMAND_OBJECTS[cmd.intern] || ERROR_OBJ).execute(vm, args)
    end
  end
end