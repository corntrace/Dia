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

  assert('Dia::Sandbox#exception() returns nil if called before ' \
         'Dia::Sandbox#run()') do
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES) do
                # ...
              end
    equal(nil, sandbox.exception())
  end

  assert('Dia::Sandbox#exception() returns nil after a second call') do
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES) do 
      raise()
    end
  
    sandbox.run()
    sleep(0.1)
    equal(RuntimeError, sandbox.exception().class)
    equal(nil, sandbox.exception())
  end

end
