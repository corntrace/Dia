suite('Dia::RubyBlock') do

  suite('#rescue_exception?()') do
    exercise('@rescue is set to false, ' \
             '#rescue_exception?() returns false') do
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_OS_SERVICES) do
        #...
      end
      @result = sandbox.rescue_exception?()
    end

    verify(nil) do
      @result == false      
    end

    exercise('@rescue is set to true, ' \
             '#rescue_exception?() returns true') do
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_OS_SERVICES) do
      end
      sandbox.rescue_exception = true
      @result = sandbox.rescue_exception?()
    end

    verify(nil) do
      @result == true
    end
  end

  suite('#exception()') do 
    setup do 
      @result = nil
    end

    exercise('@rescue is set to false, ' \
             '#run() called, ' \
             '#exception() returns nil to the parent process.') do
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_OS_SERVICES) do
        begin
          raise()
        rescue
        end
      end
      sandbox.run()
      @result = sandbox.exception()
    end

    verify(nil) do
      @result == nil
    end

    exercise('@rescue is set to true, ' \
             '#run() called, ' \
             'exception raised, ' \
             '#exception() returns raised exception to the parent process.' ) do

      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_OS_SERVICES) do
        raise()
      end
      sandbox.rescue_exception = true
      sandbox.run()
      @result = sandbox.exception().class()
    end

    verify(nil) do
      @result == RuntimeError
    end

    exercise('@rescue is set to true, ' \
             '#run() called, ' \
             'exception raised, ' \
             '@rescue is set to false, ' \
             '#exception() returns raised exception to parent process') do

      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) do
        raise()
      end
      sandbox.rescue_exception = true
      sandbox.run()
      sandbox.rescue_exception = false
      @result = sandbox.exception().class()
    end

    verify(nil) do 
      @result == RuntimeError
    end

  end

  suite('#run()') do
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
          @writer.close()
        end
      end

      sandbox.run()
      
      @writer.close()
      @result = @reader.gets()
      @reader.close()
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
          @writer.close()
        end
      end
      

      sandbox.run()

      @writer.close()
      @result = @reader.gets()
      @reader.close()
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
          @writer.close()
        end
      end
      
      sandbox.run()

      @writer.close()
      @result = @reader.gets()
      @reader.close()
    end

    verify(nil) do
      @result == 'true'
    end

    exercise('Confirm the profile ' \
             'Dia::Profiles::NO_NETWORKING ' \
             'is creating a working sandbox environment') do
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_NETWORKING) do  
        begin
          @reader.close()
          TCPSocket.open('http://www.youtube.com', 80)
          @writer.write('false')
        rescue SocketError => e
          @writer.write('true')
        end
      end
      
      sandbox.run()
      
      @writer.close()
      @result = @reader.gets()
      @reader.close()    
    end

    verify(nil) do
      @result == 'true'
    end

    exercise('#run() called, ' \
             'returns the Process ID(PID) of spawned process as a Fixnum') do
      
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_OS_SERVICES) do
        # ..
      end

      @result = sandbox.run()
    end

    verify(nil) do
      @result.class == Fixnum
    end

  end

  suite('#run_nonblock()') do
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
          @writer.close()
        end
      end

      sandbox.run_nonblock()
      sleep(1)

      @writer.close()
      @result = @reader.gets()
      @reader.close()
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
          @writer.close()
        end
      end
      

      sandbox.run_nonblock()
      sleep(1)

      @writer.close()
      @result = @reader.gets()
      @reader.close()
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
          @writer.close()
        end
      end
      
      sandbox.run_nonblock()
      sleep(1)

      @writer.close()
      @result = @reader.gets()
      @reader.close()
    end

    verify(nil) do
      @result == 'true'
    end

    exercise('Confirm the profile ' \
             'Dia::Profiles::NO_NETWORKING ' \
             'is creating a working sandbox environment') do
      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_NETWORKING) do  
        begin
          @reader.close()
          TCPSocket.open('http://www.youtube.com', 80)
          @writer.write('false')
        rescue SocketError => e
          @writer.write('true')
        end
      end
      
      sandbox.run_nonblock()
      sleep(1)
      
      @writer.close()
      @result = @reader.gets()
      @reader.close()    
    end

    verify(nil) do
      @result == 'true'
    end

    exercise('#run_nonblock() called, ' \
             'returns the Process ID(PID) of spawned process as a Fixnum') do

      sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) do
        # ..
      end

      @result = sandbox.run_nonblock()
    end

    verify(nil) do
      @result.class() == Fixnum
    end

  end

end

