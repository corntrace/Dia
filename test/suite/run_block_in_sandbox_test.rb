# TODO: Add assertion for Dia::Profiles::NO_OS_SERVICES

BareTest.suite do 'Dia::Sandbox#run_with_block'

  setup do
    @reader, @writer = IO.pipe
  end
  
  assert 'will not be able to access the internet' do
    Dia::Sandbox.new(Dia::Profiles::NO_INTERNET).run_with_block do
      begin
        @reader.close
        TCPSocket.open('http://www.google.com', 80)
        @writer.write('false')
      rescue SystemCallError => e
        @writer.write('true')
      end
    end
    
    @writer.close
    successful = @reader.gets
    @reader.close
    
    equal('true', successful)
  end
    
  assert 'will not be able to write the filesystem' do
    Dia::Sandbox.new(Dia::Profiles::NO_FILESYSTEM_WRITE).run_with_block do
      begin
        @reader.close
        File.open('foo.txt', 'w')
        @writer.write('false')
      rescue SystemCallError => e
        @writer.write('true')
      end
    end

    @writer.close
    successful = @reader.gets
    @reader.close
    
    equal('true', successful)
  end
  
  assert 'will not be able to write to the filesystem except when writing to /tmp' do
    Dia::Sandbox.new(Dia::Profiles::NO_FILESYSTEM_WRITE_EXCEPT_TMP).run_with_block do
      
      marshal = []
      begin
        marshal = Marshal.dump(marshal)
        @reader.close
        File.open('foo.txt', 'w')
        @writer.write('false')
      rescue SystemCallError => e
        marshal = Marshal.dump(Marshal.load(marshal) << 'true')
      end
      
      begin
        File.open('/tmp/foo.txt', 'w') do |f|
          f.puts 'foo'
        end
        @writer.write(marshal = Marshal.dump(Marshal.load(marshal) << 'true'))
      rescue SystemCallError => e
        @writer.write('false')
      end
    end
    
    @writer.close
    successful = Marshal.load(@reader.gets)
    @reader.close
    
    equal(['true', 'true'], successful)
  end
  
  assert 'will not be able to do any socket based communication' do
    Dia::Sandbox.new(Dia::Profiles::NO_NETWORKING).run_with_block do  
      begin
        @reader.close
        TCPSocket.open('http://www.youtube.com', 80)
        @writer.write('false')
      rescue SocketError => e
        @writer.write('true')
      end
    end
    
    @writer.close
    successful = @reader.gets
    @reader.close
    
    equal('true', successful)
  end
  
end