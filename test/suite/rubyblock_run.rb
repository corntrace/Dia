BareTest.suite('Dia::RubyBlock#run', :tags => [ :'2.0' ]) do
  assert('When @rescue is set to false, #exception() will return nil from ' \
         'the parent process') do
    sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_OS_SERVICES) do
      begin
        raise()
      rescue
      end
    end
    sandbox.run()
    equal(nil, sandbox.exception()) 
  end

  assert('When @rescue is set to true, #exception will raise a subclass of ' \
         'exception from the parent process') do
    sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_OS_SERVICES) do
      raise()
    end
    sandbox.rescue_exception = true
    sandbox.run()
    equal(RuntimeError, sandbox.exception().class())
  end
end
