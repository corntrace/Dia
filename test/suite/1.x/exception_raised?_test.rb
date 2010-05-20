BareTest.suite('Dia::Sandbox#exception_raised?()', 
               :tags => [ :'1.x'] ) do
  assert('#exception_raised?() returns false when no exception has been ' \
         'raised') do
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES) do
      # ...
    end 
    sandbox.run()
    sleep(0.1)
    equal(false, sandbox.exception_raised?())
  end

  assert('#exception_raised?() returns true when an exception has been ' \
         'raised') do
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES) do
      raise(StandardError, 'Exception')
    end
    sandbox.run()
    sleep(0.1)
    equal(true, sandbox.exception_raised?())
  end
end
