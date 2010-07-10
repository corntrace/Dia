module Dia

  class RubyBlock

    require('io/wait')  
    include Dia::SharedFeatures

    def initialize(profile, &block)
      @profile = profile
      @block   = block
      @rescue  = false
    end

    # This method will tell you whether or not a raised exception will be 
    # rescued by Dia in your sandbox.
    #
    # @see    #rescue_exception= See #rescue_exception= for enabling the capture
    #                            of raised exceptions in your sandbox.
    #
    # @see    #exception         See the #exception method for accessing an 
    #                            exception raised in your sandbox.
    #
    # @return [Boolean] Returns true or false.
    # @since  2.0.0
    def rescue_exception?()
      !!@rescue
    end

    # This method can enable or disable a feature that will capture 
    # exceptions that are raised in your sandbox.  
    # This feature is useful because a sandbox is spawned inside a child 
    # process, and communicating data between the two processes can be 
    # cumbersome at times.
    #
    # @param  [Boolean] Boolean A boolean is recommended  but a 
    #                           true(ish) or false(ish) value is suffice.  
    #
    # @return [Boolean] Returns the passed argument.
    #
    # @see    #exception See #exception for information on how to access 
    #                    an exception raised in your sandbox.
    #
    # @since 2.0.0
    def rescue_exception=(boolean)
      @rescue = boolean
    end

    # This method will return the exception last raised in your sandbox. 
    #
    # When this method is being used in conjuction with {#run_nonblock}, you
    # may need to call sleep for a duration of 1 to 2 seconds before the
    # exception will be available to the parent process.
    # 
    # @return [Exception, nil]  Returns an instance or subclass instance of 
    #                           Exception, or nil when there is no exception 
    #                           available.  
    #                           Every call to {#run} or {#run_nonblock} will 
    #                           reset the instance variable referencing 
    #                           an exception to nil.
    #
    # @see #rescue_exception=   This feature is disabled by default.  
    #                           See how to enable it.
    #
    # @since 1.5
    def exception()
      if (!@read.nil?() && !@write.nil?()) && 
         (!@read.closed?() && !@write.closed?()) && (@read.ready?())
        @write.close()
        @e = Marshal.load(@read.readlines().join())
        @read.close()
      end
      @e
    end

    # The run method will spawn a child process and run the block supplied to 
    # the constructor under a sandboxed environment.  
    # This method will block. See {#run_nonblock} for the non-blocking form of
    # this method.
    #
    # @param  [Arguments] Arguments   A variable amount of arguments that will 
    #                                 be passed onto the block supplied to the 
    #                                 constructer. Optional.
    #
    # @raise  [SystemCallError]       A number of subclasses of SystemCallError 
    #                                 may be raised if the block violates 
    #                                 sandbox restrictions.
    #
    # @raise  [Dia::SandboxException] Will raise 
    #                                 {Dia::Exceptions::SandboxException}
    #                                 if it was not possible to initialize
    #                                 a sandbox environment. 
    #
    # @return [Fixnum]                The Process ID(PID) that the sandbox has
    #                                 been launched under.
    def run(*args)
      if @rescue
        initialize_streams()      
      end

      launch(*args) 

      # parent ..
      _, @exit_status = Process.wait2(@pid)
      @pid
    end

    # An identical, but non-blocking form of {#run}.
    def run_nonblock(*args)
      if @rescue
        initialize_streams()
      end

      launch(*args)

      @exit_status = Process.detach(@pid)
      @pid
    end

    private
      # @api private
      def launch(*args)
        @e = nil
        @pid = fork do
          initialize_sandbox()
          if @rescue
            begin
              @block.call(*args)
            rescue SystemExit, SignalException, NoMemoryError => e 
              raise(e)
            rescue Exception => e      
              @write.write(Marshal.dump(e))
            ensure
              @write.close()
              @read.close()
            end
          else
            @block.call(*args)
          end
        end
      end

      # @api private
      def initialize_sandbox()
        if Dia::Functions.sandbox_init(FFI::MemoryPointer.from_string(@profile),
                                       0x0001, 
                                       err = FFI::MemoryPointer.new(:pointer)) \
                                       == -1

          raise(Dia::SandboxException, "Failed to initialize sandbox" \
                                       "(#{err.read_pointer.read_string})")
        end
      end

      # @api private
      def initialize_streams()
        if ( (!@read.nil?() && !@write.nil?()) && 
             (!@read.closed?() && !@write.closed?()) )
          @read.close()
          @write.close()
        end
        @read, @write = IO.pipe()
      end
 
  end

end
