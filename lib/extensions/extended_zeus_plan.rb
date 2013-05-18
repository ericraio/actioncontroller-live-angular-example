
#module Extensions
  #class ExtendedZeusPlan < Zeus::Rails
    #def dbconsole
      #require 'rails/commands/dbconsole'

      #meth = Rails::DBConsole.method(:start)

      ## `Rails::DBConsole.start` has been changed to load faster in 
      ## https://github.com/rails/rails/commit/346bb018499cde6699fcce6c68dd7e9be45c75e1
      ##
      ## This will work with both versions.
      #if meth.arity.zero?
        #Rails::DBConsole.start
      #else
        #Rails::DBConsole.start(Rails.application)
      #end
    #end

    #def cucumber_environment
      #require 'cucumber/rspec/disable_option_parser'
      #require 'cucumber/cli/main'
      #@cucumber_runtime = Cucumber::Runtime.new
    #end

    #def cucumber
      #cucumber_main = Cucumber::Cli::Main.new(ARGV.dup)
      #exit cucumber_main.execute!(@cucumber_runtime)
    #end
  #end
#end

#Zeus.plan = ExtendedZeusPlan.new
