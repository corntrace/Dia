module Dia
  
  class Sandbox
  
    require('io/wait')

    include Dia::CommonAPI
    
    attr_reader :app
    attr_reader :profile
    attr_reader :pid
    attr_reader :blk

    # The constructer accepts a profile as the first parameter, and an 
    # application path _or_ block as its second parameter.  
    #
    # @example
    #
    #     # Passing an application to the constructer ..
    #     sandbox = Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES, 'ping google.com')
    #     
    #     # Passing a block to the constructer ..
    #     sandbox = Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES) do
    #       File.open('foo.txt', 'w') do |f|
    #         f.puts "bar"
    #       end
    #     end
    #
    # @see Dia::Sandbox#run See Dia::Sandbox#run for executing the sandbox.
    #
    # @param  [Constant]     Profile      The profile to be used when creating a
    #                                     sandbox.
    #
    # @param  [Proc]         Proc         A proc object you want to run under a 
    #                                     sandbox.   
    #                                     Omit the "Application" parameter if 
    #                                     passed.
    #
    # @param  [String]       Application  The path to an application you want
    #                                     to run under a sandbox.   
    #                                     Omit the "Proc" parameter if passed.
    # @return [Dia::SandBox] Returns an instance of Dia::SandBox
    
    def initialize(profile, app=nil, &blk)
      if (app && blk) || (app.nil? && blk.nil?) 
        raise ArgumentError, 'Application or Proc object expected'
      end
      
      @app      = app
      @blk      = blk
      @profile  = profile
      @pid      = nil
      initialize_streams()
    end

    # The #exception_raised?() method returns true if an exception has been 
    # raised in the last call to #run(), and false otherwise.
    #
    # @return [Boolean] Returns true or false.
    def exception_raised?()
      !!@e
    end

    # The exception() method returns the last exception raised after a 
    # a call to #run(), or nil.
    #
    # Every call to #run() resets the variable storing the exception object
    # to nil, and it will only be a non-nil value if the last call to #run()
    # raised an exception.
    #
    # This method can be used if you need access(from the parent process)
    # to an exception raised in your sandbox.
    #
    # If the sandbox raises an exception rather quickly, you might need to
    # sleep(X) (0.3-0.5s on my machine) before the parent process 
    # recieves the exception.
    # 
    # @return [Exception, nil]  Returns an instance or subclass instance of 
    #                           Exception when successful, and nil when 
    #                           there is no exception available.
    # @since 1.5
    def exception()
      @write.close()
      if @read.ready?()
        @e = Marshal.load(@read.readlines().join())
      end
      @read.close()
      initialize_streams()
      @e
    end

    # The run method will spawn a child process and run the application _or_
    # block supplied to the constructer under a sandbox.  
    # This method will not block.
    #
    # @param  [Arguments] Arguments   A variable amount of arguments that will 
    #                                 be passed onto the block supplied to the 
    #                                 constructer. Optional.
    #
    # @raise  [SystemCallError]       In the case of running a block, a number 
    #                                 of subclasses of SystemCallError may be 
    #                                 raised if the block violates sandbox 
    #                                 restrictions.
    #                                 The parent process will not be affected 
    #                                 and if you wish to catch exceptions you 
    #                                 should do so in your block.
    #
    # @raise  [Dia::SandboxException] Will raise Dia::SandboxException in a 
    #                                 child process and exit if the sandbox 
    #                                 could not be initiated.
    #
    # @return [Fixnum]                The Process ID(PID) that the sandboxed 
    #                                 application is being run under.
    def run(*args)
      @e = nil
      initialize_streams()      
      @pid = fork do
        begin
          if sandbox_init(FFI::MemoryPointer.from_string(@profile), 
                          0x0001, 
                          err = FFI::MemoryPointer.new(:pointer)) == -1

            raise(Dia::SandboxException, "Failed to initialize sandbox" \
                                         "(#{err.read_pointer.read_string})")
          end
          
          if @app
            exec(@app)
          else
            @blk.call(*args)
          end

        rescue SystemExit, Interrupt => e 
          raise(e)
        rescue Exception => e        
          @write.write(Marshal.dump(e))
        ensure
          @write.close()
          @read.close()
        end
      end

      # parent ..
      @thr = Process.detach(@pid)
      @pid
    end
   
    # The exit_status method will return the exit status of the child process 
    # running in a sandbox.  
    # This method *will* block until the child process exits.
    #
    # @return [Fixnum, nil] Returns the exit status of the process that ran
    #                       under a sandbox.
    #                       Returns nil if Dia::Sandbox#run has not 
    #                       been called yet, or if the process stopped
    #                       abnormally(ie: through SIGKILL, or #terminate).
    # @since 1.5
    def exit_status()
      @thr.value().exitstatus() unless @thr.nil?
    end

    # The terminate method will send SIGKILL to a process running in a sandbox.
    # By doing so, it effectively terminates the sandbox.
    #
    # @raise  [SystemCallError] It may raise a number of subclasses of 
    #                           SystemCallError if a call to Process.kill 
    #                           was unsuccessful ..
    #
    # @return [Fixnum, nil]     It will return 1 when successful, and 
    #                           it will return "nil" if Dia::Sandbox#run() 
    #                           has not been called yet. 
    def terminate()
      Process.kill('SIGKILL', @pid) unless @pid.nil?
    end
    
    # The running? method will return true if a sandbox is running, 
    # and false otherwise.  
    #
    # @raise  [SystemCallError] It may raise a subclass of SystemCallError if 
    #                           you do not have permission to send a signal
    #                           to the process running in a sandbox.
    #
    # @return [Boolean,nil]     It will return true or false if the sandbox 
    #                           is running or not, and it will return "nil"
    #                           if Dia::Sandbox#run has not been called yet.
    def running?()
      if @pid.nil?
        nil
      else
        begin
          Process.kill(0, @pid)
          true
        rescue Errno::ESRCH
          false
        end
      end
    end
   
    private
    
    def initialize_streams()
      @read, @write = IO.pipe()
    end
 
  end
  
end
