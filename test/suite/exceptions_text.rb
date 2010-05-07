BareTest.suite('Exceptions', :tags => [ :exception ]) do
  assert('Dia::SandboxException is raised if a call to sandbox_init() fails') do
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES) do 
      # ...
    end
    sandbox.instance_variable_set("@profile", "i am going to break")
    sandbox.run
    sleep(0.1)
    equal(Dia::SandboxException, sandbox.exception().class)
  end

  assert('#exception() will return an exception raised in the sandbox') do
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES) do
      raise()
    end
  
    sandbox.run()
    sleep(0.1)
    equal(RuntimeError, sandbox.exception.class())
  end

  assert('#exception() returns nil if called before ' \
         'Dia::Sandbox#run()') do
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES) do
                # ...
              end
    equal(nil, sandbox.exception())
  end

  assert('#exception() returns nil after a second call') do
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES) do 
      raise()
    end
  
    sandbox.run()
    sleep(0.1)
    equal(RuntimeError, sandbox.exception().class)
    equal(nil, sandbox.exception())
  end

  assert('#exception() can marshal data containing one or more \n') do
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES) do 
      fork {}
    end
    sandbox.run()
    sleep(0.5)
    equal(Errno::EPERM, sandbox.exception().class)
  end

end
