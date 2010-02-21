BareTest.suite "Dia::Sandbox#running?" do
  
  assert 'Confirm that Dia::Sandbox#running? returns true when a sandbox is running' do
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES) do
      sleep(20)
    end
    
    sandbox.run
    equal(true, sandbox.running?)
    sandbox.terminate
  end

  assert 'Confirm that Dia::Sandbox#running? returns false when a sandbox is not running' do
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES) do
      sleep(20)
    end
    sandbox.run
    sandbox.terminate
    sleep(1)
    equal(false, sandbox.running?)
  end
  
end