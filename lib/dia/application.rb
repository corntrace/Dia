module Dia

  class Application
    include Dia::SharedFeatures


    # @param [String] Profile     Accepts one of five profiles found under the {Dia::Profiles} 
    #                             module.
    #
    # @param [String] Application Accepts a path to an application.
    #
    # @raise [ArgumentError]      It may raise an ArgumentError if it isn't possible to use a
    #                             particular profile with this type of sandbox.
    def initialize(profile, app)
      @profile = profile
      @app     = app
      raise(ArgumentError, "Dia::Profiles::NO_OS_SERVICES is not applicable to the Application " \
                           "sandbox.") if Dia::Profiles::NO_OS_SERVICES == @profile
    end

    # This method will spawn a child process, initialize a sandbox environment, and call exec()
    # to start your application.
    # 
    # @return [Fixnum]  Returns the Process ID(PID) of the child process used to execute an 
    #                   application in a sandbox.
    def run
      @pid = fork do 
        initialize_sandbox
        exec(@app)
      end

      _, @exit_status = Process.wait2(@pid)
      @pid
    end

    # An identical but non-blocking form of {#run}.
    def run_nonblock
      @pid = fork do
        initialize_sandbox
        exec(@app)
      end

      @exit_status = Process.detach(@pid)
      @pid
    end

  end

end
