BareTest.suite('Dia::SharedFeatures#exit_status') do
  assert('The number "10" is returned as the exit sttus of a child process') do
    sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) do
      exit(10)
    end
    sandbox.run
    equal(10, sandbox.exit_status)
  end

  assert("nil will be returned if Dia::RubyBlock#run hasn't been called before" \
         "a call to #exit_status") do
    sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) do
    end
    equal(nil, sandbox.exit_status)
  end

end

