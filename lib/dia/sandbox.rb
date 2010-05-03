module Dia
  
  class Sandbox
  
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
      @pid = fork do
        if sandbox_init(FFI::MemoryPointer.from_string(@profile), 
                        0x0001, 
                        err = FFI::MemoryPointer.new(:pointer)) == -1

          raise(Dia::SandboxException, "Failed to initialize sandbox" /
                                       "(#{err.read_pointer.read_string})")
        end
        
        if @app
          exec(@app)
        else
          @blk.call(*args)
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
    
  end
  
end
