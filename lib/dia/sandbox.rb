module Dia
  
  class Sandbox
  
    include Dia::CommonAPI
    
    attr_reader :app
    attr_reader :profile
    attr_reader :pid
    attr_reader :blk
    
    # The constructer accepts a profile as the first parameter, and an application path _or_ block as its second parameter.  
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
    # @param  [Constant]     Profile      The profile to be used when creating a sandbox.
    # @param  [Proc]         Proc         A proc object you want to run under a sandbox.   
    #                                     Omit the "Application" parameter if passed.
    # @param  [String]       Application  The path to an application you want to run under a sandbox.   
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
    
    # The run method will spawn a child process and run the application _or_ block supplied to the constructer under a sandbox.  
    # This method will not block.
    #
    # @param  [Arguments]             A variable amount of arguments that will be passed onto the block supplied to the constructer. 
    #
    # @raise  [SystemCallError]       In the case of running a block, a number of subclasses of SystemCallError may be raised if the block violates sandbox restrictions.
    #                                 The parent process will not be affected and if you wish to catch exceptions you should do so in your block.
    #
    # @raise  [Dia::SandboxException] Will raise Dia::SandboxException in a child process and exit if the sandbox could not be initiated.
    # @return [Fixnum]                The Process ID(PID) that the sandboxed application is being run under.
    def run(*args)
      
      @pid = fork do
        if ( ret = sandbox_init(@profile, 0x0001, error = FFI::MemoryPointer.new(:pointer)) ) != 0
          raise Dia::SandboxException, "Couldn't sandbox #{@app}, sandbox_init returned #{ret} with error message: '#{error.get_pointer(0).read_string}'"
        end
        
        if @app_path
          exec(@app_path)
        else
          @blk.call(*args)
        end
      end
      
      # parent ..
      Process.detach(@pid)
    end
    
    # The terminate method will send SIGKILL to a process running in a sandbox.
    # By doing so, it effectively terminates the sandbox.
    #
    # @raise  [SystemCallError] It may raise a number of subclasses of SystemCallError if a call to Process.kill was unsuccessful ..
    # @return [Fixnum]          It will return 1 when successful ..
    def terminate
      Process.kill('SIGKILL', @pid)
    end
    
    # The running? method will return true if a sandbox is running, and false otherwise.
    # It does so by sending a signal to the process running a sandbox.
    #
    # @raise  [SystemCallError] It may raise a subclass of SystemCallError if you do not have permission to send a signal
    #                           to the process running in a sandbox.
    #
    # @return [Boolean]         It will return true or false.
    def running?
      begin
        Process.kill(0, @pid)
        true
      rescue Errno::ESRCH
        false
      end
    end
    
  end
  
end
