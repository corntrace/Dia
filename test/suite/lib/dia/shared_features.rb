suite('Dia::SharedFeatures') do

  suite('RubyBlock') do

    suite('#exit_status') do

      setup do
        @result = nil
      end

      exercise('#run is called, exits process with status of 10. ') do
        sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) { exit(10) }
        sandbox.run
        @result = sandbox.exit_status
      end

      verify('#exit_status returns 10') do
        @result == 10
      end

      exercise('Neither #run or #run_nonblock has been called. ') do
        sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) { }
        @result = sandbox.exit_status
      end

      verify('#exit_status returns nil') do
        @result == nil
      end

    end

    suite('#terminate') do

      setup do 
        @result  = nil
        @sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_OS_SERVICES) { sleep(10) }
      end
 
      exercise('#run_nonblock is called, spawned process sleeps, #terminate sent to process. ') do
        @sandbox.run_nonblock
        @result = @sandbox.terminate
      end

      verify('#terminate returns 1.') do
        @result == 1
      end
      
      exercise('#run_nonblock is called, spawned process sleeps, #terminate sent to process. ') do
        @sandbox.run_nonblock
        @sandbox.terminate
        @result = @sandbox.exit_status
      end

      verify('#exit_status returns nil.') do
        @result == nil
      end

      exercise('Neither #run or #run_nonblock has been called. ') do        
        sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) { }
        @result = sandbox.terminate
      end

      verify('#terminate returns nil') do
        @result == nil
      end

    end

    suite('#running?') do 

      setup do
        @result = nil
      end

      exercise('#run_nonblock is called, spawned process sleeps. ') do
        sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) { sleep(10) }
        sandbox.run_nonblock
        @result = sandbox.running?
        sandbox.terminate
      end

      verify('#running? returns true') do
        @result == true
      end

      exercise('#run is called, process exits immediately. ') do
        sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) { exit }
        sandbox.run
        @result = sandbox.running?
      end

      verify('#running? returns false') do
        @result == false
      end

      exercise('Neither #run or #run_nonblock has been called. 'do
        sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) { }
        @result = sandbox.running?
      end

      verify('#running? returns nil') do
        @result == nil
      end

    end

  end
end
