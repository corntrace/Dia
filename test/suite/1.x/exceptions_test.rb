BareTest.suite('Exceptions', :tags => [ :'1.x' ]) do
  assert('Dia::SandboxException is raised if a call to sandbox_init() fails') do
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES) do 
      # ...
    end
    sandbox.instance_variable_set("@profile", "i am going to break")
    sandbox.run
    sleep(0.1)
    equal(Dia::SandboxException, sandbox.exception().class)
  end
end

