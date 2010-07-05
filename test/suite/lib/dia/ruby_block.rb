suite('Dia::RubyBlock') do
  suite('#exception()') do 
    setup do 
      @result = nil
    end

    exercise('@rescue is set to false, #run() is executed, ' \
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
             '#run() is executed, ' \
             'an exception is raised in sandbox, ' \
             '#exception() returns the raised exception ' \
             'to the parent process.') do
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
  end

  suite('#run()') do
    setup do
      @result          = nil
      @reader, @writer = IO.pipe
    end

    exercise('Confirm the profile Dia::Profiles::NO_INTERNET is creating a ' \
             'working sandbox environment.') do      
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

    exercise('Confirm the profile Dia::Profiles::NO_FILESYSTEM_WRITE is ' \
             'creating a working sandbox environment.') do      
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

  end
end

