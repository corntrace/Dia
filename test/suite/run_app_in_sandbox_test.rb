# See /test/suite/run_block_in_sandbox_test.rb for tests that confirm sandboxes are successfully created ..
BareTest.suite 'Dia::Sandbox#run' do
  
  assert 'Trying to run an application in a sandbox without supplying an application will raise an ArgumentError' do
    raises(ArgumentError) do
      Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES).run
    end
  end
  
end