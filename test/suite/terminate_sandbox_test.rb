BareTest.suite 'Dia::Sandbox#terminate', :tags => [ :terminate ] do
  
  assert 'A spawned sandbox will be terminated with the #terminate method' do
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES) do
      sleep(100)
    end
    
    sandbox.run
    sandbox.terminate
    sleep(1) # Allow the process time to die ..
    
    begin
      Process.kill('SIGKILL', sandbox.pid)
      false
    rescue Errno::ESRCH => e
      true
    end
    
  end
  
  assert("nil will be returned if Dia::Sandbox#run hasn't been called before a call to #terminate") do
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_INTERNET) do
      # ...
    end

    equal(nil, sandbox.terminate)
  end

end
