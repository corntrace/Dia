module Dia
  
  class SandBox
  
    include Dia::CommonAPI
    
    attr_accessor :app_path
    attr_accessor :profile
    attr_accessor :pid
    
    # @param  [Constant]     Profile      The profile to be used when creating a sandbox.
    # @param  [String]       Application  The path to an application you want to sandbox. Optional.
    # @return [Dia::SandBox] Returns an instance of Dia::SandBox
    def initialize(profile = Dia::Profiles::NO_OS_SERVICES, app_path=nil)
      @app_path = app_path
      @profile = profile
    end
    
    # The run method will spawn a child process and run the supplied application in a sandbox.
    #  
    # @raise  [ArgumentError]         Will raise an ArgumentError if an application has not been supplied to 
    #                                 the constructer.
    # @raise  [Dia::SandBoxException] Will raise Dia::SandBoxException if the sandbox could not be initiated.
    # @return [Fixnum] The Process ID(PID) that the sandboxed application is being run under.
    def run
      raise ArgumentError, "No application path supplied"  if @app_path.nil?
      
      @pid = fork do
        unless ( ret = sandbox_init(@profile, 0x0001, error = FFI::MemoryPointer.new(:pointer)) ) == 0
          raise Dia::SandBoxException, "Couldn't sandbox #{@app_path}, sandbox_init returned #{ret} with error message: '#{error.get_pointer(0).read_string}'"
        end
        exec(@app_path)
      end
    end
  
    # The run\_with\_block method will spawn a child process and run a supplied block of ruby code in a sandbox.
    #
    # It may raise any number of exceptions if the sandbox could be initiated ..  
    # It depends on the restrictions of the sandbox and if the block actually violates a restriction imposed by 
    # the sandbox .. In any case, the parent process will not be affected and if you want to catch an exception you
    # should do so in your block.
    #
    # @raise  [Dia::SandBoxException] Will raise Dia::SandBoxException if the sandbox could not be initiated. 
    # @return [Fixnum] The Process ID(PID) that the sandboxed block of code is being run under.
    def run_with_block &blk
      @pid = fork do
         unless ( ret = sandbox_init(@profile, 0x0001, error = FFI::MemoryPointer.new(:pointer)) ) == 0
           raise Dia::SandBoxException, "Couldn't sandbox #{@app_path}, sandbox_init returned #{ret} with error message: '#{error.get_pointer(0).read_string}'"
         end
         yield
      end
    end
    
  end
  
end
