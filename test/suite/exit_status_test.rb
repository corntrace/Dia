BareTest.suite('Dia::Sandbox#exit_status') do
  assert('The exit status of a child process running under a sandbox is returned.') do
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_INTERNET) do
      exit(10)
    end
    sandbox.run
    equal(10, sandbox.exit_status)
  end

  assert("nil will be returned if Dia::Sandbox#run hasn't been called before a call to #exit_status") do
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_INTERNET) do
    end
    equal(nil, sandbox.exit_status)
  end

end
