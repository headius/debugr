require 'debugr/jdi'
require 'debugr/vm'
require 'debugr/thread_util'
require 'debugr/commands'
require 'debugr/console'
require 'readline'

module Debugr
  def self.launch(argv)
    Console.new(argv)
  end
end