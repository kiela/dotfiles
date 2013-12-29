require 'rubygems'
require 'awesome_print'
require 'fancy_irb'
require 'interactive_editor'
require 'looksee'
require 'method_source'

AwesomePrint.irb!
AwesomePrint.defaults = {:indent => 2}
FancyIrb.start :rocket_mode => false,
  :colorize => { :result_prompt => :green },
  :result_proc => proc { |c| c.last_value.awesome_inspect }

puts "> all systems loaded <"
