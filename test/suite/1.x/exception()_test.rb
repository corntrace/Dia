BareTest.suite('Dia::Sandbox#exception()', :tags => [ :'1.x' ] ) do
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

  assert('#exception() returns an exception object the first' \
          ' and second time it is called after a single call to #run()') do
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES) do 
      raise()
    end
  
    sandbox.run()
    sleep(0.1)
    equal(RuntimeError, sandbox.exception().class)
    equal(RuntimeError, sandbox.exception().class)
  end

  assert('#exception() will be set to nil after the first call to ' \
         '#run raises an exception, and the second does not') do

    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES) do 
      raise()
    end
    
    sandbox.run()
    sleep(0.1)
    equal(RuntimeError, sandbox.exception().class)
    sandbox.instance_variable_set("@blk", proc { })
    sandbox.run()
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
