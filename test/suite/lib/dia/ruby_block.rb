suite('Dia::RubyBlock') do

  suite('misc') do

    exercise("An invalid profile is passed to Dia::RubyBlock.new, and #run is called.") do
      sandbox = Dia::RubyBlock.new('invalid_profile') { }
      sandbox.rescue_exception = true
      sandbox.run
      @result = sandbox.exception.klass
    end
    
    verify('Dia::RubyBlock#exception returns an instance of Dia::Exceptions::SandboxException') do
      @result == "Dia::Exceptions::SandboxException"
    end

  end

  suite('#initialize') do

    setup do
      @result = nil
    end

    exercise('No block is passed to the constructor. ') do
      begin
        Dia::RubyBlock.new(Dia::Profiles::NO_OS_SERVICES)
      rescue ArgumentError => e
        @result = true
      end
    end

    verify('ArgumentError is raised.') do 
      @result      
    end

  end

  suite('#pid') do
    
    exercise('#run is called, then #pid is called. ') do
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_OS_SERVICES) { }
      sandbox.run
      @result = sandbox.pid
    end

    verify('#pid returns a Fixnum object') do
      @result.class == Fixnum
    end

  end
  
  suite('#stderr') do

    exercise('@rescue set to true, @redirect_stderr set to true, #run called, ' \
             '$stderr written to. ') do
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) do 
        $stderr.print "Hello, world $stderr!"
      end
      sandbox.rescue_exception = true
      sandbox.redirect_stderr  = true
      sandbox.run
      @result = sandbox.stderr
    end

    verify('#stderr returns the contents of $stderr.') do
      @result == 'Hello, world $stderr!'
    end

    exercise('@rescue set to true, @redirect_stderr set to true, #run called, ' \
             'STDERR written to. ') do
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) do 
        STDERR.print "Hello, world STDERR!"
      end
      sandbox.rescue_exception = true
      sandbox.redirect_stderr  = true
      sandbox.run
      @result = sandbox.stderr
    end

    verify('#stderr returns the contents of STDERR.') do
      @result == 'Hello, world STDERR!'
    end

    exercise('@rescue set to false, @redirect_stderr set to true, #run called, ' \
             '$stderr written to. ') do
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) do 
        $stderr.print "Hello, world $stderr!"
      end
      sandbox.redirect_stderr  = true
      sandbox.run
      @result = sandbox.stderr
    end

    verify('#stderr returns the contents of $stderr.') do
      @result == 'Hello, world $stderr!'
    end

    exercise('@rescue set to false, @redirect_stderr set to true, #run called, ' \
             'STDOUT written to. ') do
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) do 
        STDERR.print "Hello, world STDERR!"
      end
      sandbox.redirect_stderr  = true
      sandbox.run
      @result = sandbox.stderr
    end

    verify('#stderr returns the contents of STDERR.') do
      @result == 'Hello, world STDERR!'
    end

    exercise('@redirect_stderr set to false, #run called. ') do
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) do
        $stderr.print ""
        STDERR.print  ""
      end
      sandbox.run
      @result = sandbox.stderr
    end

    verify('#stderr returns nil') do
      @result == nil
    end

  end

  suite('#stdout') do
    
    setup do 
      @result = nil
    end

    exercise('@rescue set to true, @redirect_stdout set to true, #run called, ' \
             '$stdout written to. ') do
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) do 
        $stdout.print "Hello, world!"
      end
      sandbox.rescue_exception = true
      sandbox.redirect_stdout  = true
      sandbox.run
      @result = sandbox.stdout
    end

    verify('#stdout returns the contents of $stdout.') do
      @result == 'Hello, world!'
    end

    exercise('@rescue set to true, @redirect_stdout set to true, #run called, ' \
             'STDOUT written to.') do
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) do 
        STDOUT.print "Goodbye, world!"
      end
      sandbox.rescue_exception = true
      sandbox.redirect_stdout  = true
      sandbox.run
      @result = sandbox.stdout
    end

    verify('#stdout returns the contents of stdout of STDOUT') do
      @result == 'Goodbye, world!'
    end

    exercise('@rescue set to false, @redirect_stdout set to true, #run called, ' \
             '$stdout written to. ') do
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) do
        $stdout.print "Hello, world!"
      end
      sandbox.redirect_stdout = true
      sandbox.run
      @result = sandbox.stdout
    end

    verify('#stdout returns the contents of $stdout') do
      @result == 'Hello, world!'
    end

    exercise('@rescue set to false, @redirect_stdout set to true, #run called, ' \
             'STDOUT written to. ') do

      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) do
        STDOUT.print "Goodbye, world!"
      end
      sandbox.redirect_stdout = true
      sandbox.run
      @result = sandbox.stdout
   end

    verify('#stdout returns the contents of STDOUT') do
      @result == 'Goodbye, world!'
    end

    exercise('@redirect_stdout set to false, #run called. ') do
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) do
        $stdout.print ""
        STDOUT.print  ""
      end
      sandbox.run
      @result = sandbox.stdout
    end

    verify('#stdout returns nil') do
      @result == nil
    end

  end

  suite('#rescue_exception?') do

    setup do
      @result  = nil
      @sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_OS_SERVICES) { }
    end

    exercise('@rescue is set to false. ') do
      @result = @sandbox.rescue_exception?
    end

    verify('#rescue_exception? returns false') do
      @result == false      
    end

    exercise('@rescue is set to true. ') do
      @sandbox.rescue_exception = true
      @result = @sandbox.rescue_exception?
    end

    verify('#rescue_exception? returns true') do
      @result == true
    end

  end

  suite('#exception', :tags => [ :exception ] ) do 
    
    setup do 
      @result  = nil
      @sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_OS_SERVICES) do
        raise
      end
    end

    exercise('@rescue is set to false, #run is called, no exception is raised. ') do
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_OS_SERVICES) do
        begin
          raise
        rescue => e
        end
      end

      @result = sandbox.exception
    end

    verify('#exception returns nil to the parent process.') do
      @result == nil
    end

    exercise('@rescue is set to true, #run is called, an exception is raised. ') do
      @sandbox.rescue_exception = true
      @sandbox.run
      @result = @sandbox.exception.klass
    end

    verify('#exception returns raised exception to the parent process.') do
      @result == "RuntimeError"
    end

    exercise('@rescue is set to true, #run is called, an is exception raised, ' \
             '@rescue is set to false. ') do
      @sandbox.rescue_exception = true
      @sandbox.run
      @sandbox.rescue_exception = false
      @result = @sandbox.exception.klass
    end

    verify('#exception returns raised exception to parent process') do 
      @result == "RuntimeError"
    end

    exercise('Exception object created, re-define #message with code that will cause ' \
             'another exception when Dia tries to serialize exception data.') do
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_OS_SERVICES) do
        e = Exception.new
        def e.message
          raise(StandardError, 'profit')
        end
        raise(e)
      end
      sandbox.rescue_exception = true
      sandbox.run
      @result = sandbox.exception
    end

    verify('Second exception is captured and returned by #exception') do
      @result
    end

  end

  suite('#run') do

    setup do
      @result          = nil
      @reader, @writer = IO.pipe
    end

    exercise('Confirm the profile ' \
             'Dia::Profiles::NO_INTERNET ' \
             'is creating a working sandbox environment.') do      
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) do
        begin
          @reader.close
          TCPSocket.open('http://www.google.com', 80)
          @writer.write('false')
        rescue SocketError, SystemCallError => e
          @writer.write('true')
        ensure
          @writer.close
        end
      end

      sandbox.run
      
      @writer.close
      @result = @reader.gets
      @reader.close
    end

    verify(nil) do
      @result == 'true'
    end

    exercise('Confirm the profile ' \
             'Dia::Profiles::NO_FILESYSTEM_WRITE ' \
             'is creating a working sandbox environment.') do
      
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_FILESYSTEM_WRITE) do
        begin
          @reader.close
          File.open('/tmp/foo.txt', 'w') { |f| f.puts('fail') }
          @writer.write('false')
        rescue SocketError, SystemCallError => e
          @writer.write('true')
        ensure 
          @writer.close
        end
      end
      

      sandbox.run

      @writer.close
      @result = @reader.gets
      @reader.close
    end

    verify(nil) do
      @result == 'true'
    end

    exercise('Confirm the profile ' \
             'Dia::Profiles::NO_FILESYSTEM_WRITE_EXCEPT_TMP ' \
             'is creating a working sandbox environment. ') do      
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_FILESYSTEM_WRITE_EXCEPT_TMP) do
        begin
          @reader.close
          out = Time.now.to_s
          File.open('/tmp/%s.dia_test' % [ out ] , 'w') { |f| f.puts('success') }
          File.open(File.join(ENV['HOME'], 'fail.txt')) { |f| f.puts('fail') }
          @writer.write('false')
        rescue SocketError, SystemCallError => e
          if File.exists?('/tmp/%s.dia_test' % [ out ])
            @writer.write('true')
          else
            @writer.write('false')
          end
        ensure 
          @writer.close
        end
      end
      
      sandbox.run

      @writer.close
      @result = @reader.gets
      @reader.close
    end

    verify(nil) do
      @result == 'true'
    end

    exercise('Confirm the profile ' \
             'Dia::Profiles::NO_NETWORKING ' \
             'is creating a working sandbox environment') do
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_NETWORKING) do  
        begin
          @reader.close
          TCPSocket.open('http://www.youtube.com', 80)
          @writer.write('false')
        rescue SocketError => e
          @writer.write('true')
        end
      end
      
      sandbox.run
      
      @writer.close
      @result = @reader.gets
      @reader.close    
    end

    verify(nil) do
      @result == 'true'
    end

    exercise('#run called. ') do
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_OS_SERVICES) { }
      @result = sandbox.run
    end

    verify('returns the Process ID(PID) of spawned process as a Fixnum') do
      @result.class == Fixnum
    end

  end

  suite('#run_nonblock') do

    setup do
      @result          = nil
      @reader, @writer = IO.pipe
    end

    exercise('Confirm the profile ' \
             'Dia::Profiles::NO_INTERNET ' \
             'is creating a working sandbox environment.') do      
      
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) do
        begin
          @reader.close
          TCPSocket.open('http://www.google.com', 80)
          @writer.write('false')
        rescue SocketError, SystemCallError => e
          @writer.write('true')
        ensure
          @writer.close
        end
      end

      sandbox.run_nonblock
      sleep(1)

      @writer.close
      @result = @reader.gets
      @reader.close
    end

    verify(nil) do
      @result == 'true'
    end

    exercise('Confirm the profile ' \
             'Dia::Profiles::NO_FILESYSTEM_WRITE ' \
             'is creating a working sandbox environment.') do      
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_FILESYSTEM_WRITE) do
        begin
          @reader.close
          File.open('/tmp/foo.txt', 'w') { |f| f.puts('fail') }
          @writer.write('false')
        rescue SocketError, SystemCallError => e
          @writer.write('true')
        ensure 
          @writer.close
        end
      end
      

      sandbox.run_nonblock
      sleep(1)

      @writer.close
      @result = @reader.gets
      @reader.close
    end

    verify(nil) do
      @result == 'true'
    end

    exercise('Confirm the profile ' \
             'Dia::Profiles::NO_FILESYSTEM_WRITE_EXCEPT_TMP ' \
             'is creating a working sandbox environment. ') do      
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_FILESYSTEM_WRITE_EXCEPT_TMP) do
        begin
          @reader.close
          out = Time.now.to_s
          File.open('/tmp/%s.dia_test' % [ out ] , 'w') { |f| f.puts('success') }
          File.open(File.join(ENV['HOME'], 'fail.txt')) { |f| f.puts('fail') }
          @writer.write('false')
        rescue SocketError, SystemCallError => e
          if File.exists?('/tmp/%s.dia_test' % [ out ])
            @writer.write('true')
          else
            @writer.write('false')
          end
        ensure 
          @writer.close
        end
      end
      
      sandbox.run_nonblock
      sleep(1)

      @writer.close
      @result = @reader.gets
      @reader.close
    end

    verify(nil) do
      @result == 'true'
    end

    exercise('Confirm the profile ' \
             'Dia::Profiles::NO_NETWORKING ' \
             'is creating a working sandbox environment') do
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_NETWORKING) do  
        begin
          @reader.close
          TCPSocket.open('http://www.youtube.com', 80)
          @writer.write('false')
        rescue SocketError => e
          @writer.write('true')
        end
      end
      
      sandbox.run_nonblock
      sleep(1)
      
      @writer.close
      @result = @reader.gets
      @reader.close    
    end

    verify(nil) do
      @result == 'true'
    end

    exercise('#run_nonblock called. ') do

      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) { }
      @result = sandbox.run_nonblock
    end

    verify('returns the Process ID(PID) of spawned process as a Fixnum') do
      @result.class == Fixnum
    end

  end

end

