BareTest.suite 'Dia::SandBox#terminate' do
  
  assert 'A spawned sandbox will be terminated with the #terminate method' do
    sandbox = Dia::SandBox.new(Dia::Profiles::NO_OS_SERVICES)
    sandbox.run_with_block do
      sleep(100)
    end
    sandbox.terminate
    sleep(1) # Allow the process time to die ..
    
    begin
      Process.kill('SIGKILL', sandbox.pid)
      false
    rescue Errno::ESRCH => e
      true
    end
    
  end
  
end