require 'rubygems'
require 'rake'
require 'yard'
require 'fileutils'
require 'baretest'

PROJECT       = 'Dia'
DOC_DIRECTORY = 'docz'

namespace :test do
  task :run do
    BareTest::CommandLine.run([], { :format => 'cli' } )
  end
end

namespace :doc do
  YARD::Rake::YardocTask.new(:create) do |t| 
    t.files    = Dir['lib/**/*.rb'] + Dir['./*.md'] 
    t.options  = %W(--title #{PROJECT} -m markdown -o #{DOC_DIRECTORY})
  end
  
  task :destroy do
    FileUtils.rm_rf(DOC_DIRECTORY)
  end
  
  task :cycle do
    Rake::Task[:'doc:destroy'].execute
    Rake::Task[:'doc:create'].execute
  end
end