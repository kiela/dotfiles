require 'rubygems'
require 'awesome_print'
require 'fancy_irb'
require 'looksee'
require 'method_source'

AwesomePrint.pry!
AwesomePrint.defaults = {:indent => 2}
FancyIrb.start :rocket_mode => false,
  :colorize => { :result_prompt => :green },
  :result_proc => proc { |c| c.last_value.awesome_inspect }

if defined? PryByebug
  puts "PryByebug defined"
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 'f', 'finish'
end

def x
  quit
end

puts "> all systems loaded <"
