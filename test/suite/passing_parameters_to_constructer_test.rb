# See /test/suite/run_block_in_sandbox_test.rb for tests that confirm sandboxes are successfully created ..
BareTest.suite 'Dia::Sandbox.new', :tags => [ :new ] do
  
  assert 'Passing no arguments to the constructer will raise an ArgumentError' do
    raises(ArgumentError) do
      Dia::Sandbox.new
    end
  end
  
  assert 'Passing only a profile to the constructer will raise an ArgumentError' do
    raises(ArgumentError) do
      Dia::Sandbox.new(Dia::Profiles::NO_INTERNET)
    end
  end
  
  assert 'Passing a profile, application path, and a block will raise an ArgumentError' do
    raises(ArgumentError) do
      Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES, 'ls') do
        puts "foo"
      end
    end
  end
  
  assert 'Passing an application path and a profile will raise nothing' do
    Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES, 'ls')
  end
  
  assert 'Passing a block and a profile will raise nothing' do
    Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES) do
      puts "foo"
    end
  end
  
end