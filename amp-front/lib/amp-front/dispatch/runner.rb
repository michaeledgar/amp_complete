##################################################################
#                  Licensing Information                         #
#                                                                #
#  The following code is licensed, as standalone code, under     #
#  the Ruby License, unless otherwise directed within the code.  #
#                                                                #
#  For information on the license of this code when distributed  #
#  with and used in conjunction with the other modules in the    #
#  Amp project, please see the root-level LICENSE file.          #
#                                                                #
#  © Michael J. Edgar and Ari Brown, 2009-2010                   #
#                                                                #
##################################################################

module Amp
  module Dispatch
    
    # This class runs Amp as a binary. Create a new instance with the arguments
    # to use, and call run! to run Amp.
    class Runner
      def initialize(args, opts={})
        @args, @opts = args, opts
      end
    
      def run!
        p @args
        global_opts, arguments = collect_options(@args)
        p global_opts
        load_ampfile!(global_opts[:ampfile]) unless global_opts[:"no-ampfile"]
        load_plugins!

        command_class = Amp::Command.for_name(arguments.join(' '))
        if command_class.nil?
          command_class = Amp::Command::Help
        else
          arguments = trim_argv_for_command(arguments, command_class)
        end
        command = command_class.new
        opts, arguments = command.collect_options(arguments)
        command.call(opts.merge(global_opts), arguments)
      end
      
      # Loads the ampfile (or whatever it's specified as) from the
      # current directory or a parent directory.
      def load_ampfile!(file, in_dir = Dir.pwd)
        variations = [file, file[0,1].upcase + file[1..-1]] # include titlecase
        to_load = variations.find {|x| File.exist?(File.join(in_dir, x))}
        if to_load
          load to_load
        elsif File.dirname(in_dir) != in_dir
          load_ampfile! File.dirname(in_dir)
        end
      end
      
      def load_plugins!
        Amp::Plugins::Base.all_plugins.each do |plugin|
          instance = plugin.new(@opts)
          instance.load!
          Amp::Plugins::Base.loaded_plugins << instance
        end
      end
      
      def trim_argv_for_command(arguments, command)
        argv = arguments.dup
        path_parts = command.inspect.gsub(/Amp::Command::/, '').gsub(/::/, ' ').split
        path_parts.each do |part|
          next_part = argv.shift
          if next_part.downcase != part.downcase
            raise ArgumentError.new(
                "Failed to parse command line option for: #{command.inspect}")
          end
        end
        argv
      end
      
      def collect_options(arguments)
        argv = arguments.dup
        _, hash = Trollop::options(argv) do
          banner "Amp - some more crystal, sir?"
          version "Amp version #{Amp::VERSION} (#{Amp::VERSION_TITLE})"
          opt :"no-ampfile", "Disables ampfiles.", :type => :flag
          opt :ampfile, "Which file to load as an ampfile", :type => :string, :default => "ampfile"
          stop_on_unknown
        end
        [hash, argv]
      end
    end
  end
end