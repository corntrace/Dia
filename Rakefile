require('rubygems')
require('rake')
require('yard')
require('fileutils')
require('baretest')

task(:default => 'test:run')

namespace(:test) do
  desc('Run the test suite (default task)')
  task(:run, :release) do |t, args|
    case(args.release)
      when nil, '1.0'
        puts('Executing tests… (For the 1.x release)')
        BareTest::CommandLine.run([], { :format => 'minimal' } )
      when '2.0'
        puts('Not yet implemented…')
      else
        puts('"%s" is an unknown option.' % [ args.release ])
    end
  end
end

namespace(:doc) do 
  DOCUMENTATION_DIRECTORY = 'yard-docs'

  yard         = YARD::Rake::YardocTask.new(:create)
  yard.files   = %w(lib/**/*.rb *.mkd)
  yard.options = %W(-m markdown -o #{DOCUMENTATION_DIRECTORY}) 

  desc('Remove YARD Documentation')
  task(:remove) do
    FileUtils.rm_rf(DOCUMENTATION_DIRECTORY)
  end
  
  desc('Cycle YARD Documentation(remove & create)')
  task(:cycle) do
    Rake::Task[:'doc:remove'].execute
    Rake::Task[:'doc:create'].execute
  end
end
