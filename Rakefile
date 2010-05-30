require('rubygems')
require('rake')
require('yard')
require('fileutils')
require('baretest')

task(:default => 'test:run')

namespace(:test) do
  desc('Run the test suite (default task)')
  task(:run, :release) do |t, args|
    puts('Executing tests…')
    BareTest::CommandLine.run([], { :format => 'minimal' } )
  end
end

namespace(:doc) do 
  DOCUMENTATION_DIRECTORY = 'yard-docs'

  yard         = YARD::Rake::YardocTask.new(:create)
  yard.files   = %w(lib/**/*.rb)
  yard.options = %W(-o #{DOCUMENTATION_DIRECTORY}) 

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
