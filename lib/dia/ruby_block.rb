module Dia

  class RubyBlock

    require('io/wait')  
    include Dia::SharedFeatures

    def initialize(profile, &block)
      @profile = profile
      @block   = block
      @rescue  = false
    end

    # This method will tell you if Dia will try to rescue an exception 
    # that could be raised inside your sandbox by returning true or false.
    #
    # By default, dia will not try to rescue the exception for you.  
    # See the setter, {#rescue_exception=} for enabling this feature, and
    # see {#exception} for accessing the exception.
    #
    # Enabling this feature is useful if you need access to an exception
    # raised in your sandbox from the parent process.
    #
    # @return [Boolean] Returns true or false.
    # @since  2.0
    def rescue_exception()
      !!@rescue
    end

    # This method can enable or disable a feature that sees Dia try to rescue
    # an exception that could be raised in your sandbox.  
    #
    # Enabling this feature is useful if you need access to an exception
    # raised in your sandbox from the parent process.
    #
    # @param  [Boolean] Boolean A boolean is recommended  but a 
    #                           true(ish) or false(ish) value is suffice.  
    #
    # @return [Boolean] Returns the argument passed.
    #
    # @since 2.0
    def rescue_exception=(boolean)
      @rescue = boolean
    end

    # This method can be used if you need access(from the parent process)
    # to an exception raised in your sandbox.
    #
    # The method returns the last exception raised after a call to {#run} 
    # or {#run_nonblock}. It returns nil if there is no exception available…
    #
    # Every call to {#run} or {#run_nonblock} resets the variable storing 
    # the exception object to nil, and it will only be a non-nil value 
    # if the last call to {#run} or {#run_nonblock} raised an exception.
    #
    # If the sandbox raises an exception rather quickly, and you're using
    # {#run_nonblock} you might need to sleep(X) (0.1-0.3s on my machine) 
    # before the parent process recieves the exception.
    # 
    # @return [Exception, nil]  Returns an instance or subclass instance of 
    #                           Exception when successful, and nil when 
    #                           there is no exception available.
    #
    # @see #rescue_exception=   This feature is disabled by default.  
    #                           See how to enable it.
    #
    # @since 1.5
    def exception()
      if @rescue
        if !@read.closed?() && !@write.closed?()
          if @read.ready?()
            @write.close()
            @e = Marshal.load(@read.readlines().join())
            @read.close()
          end
        end
      end
      @e
    end

    # The run method will spawn a child process and run the 
    # supplied block under a sandbox environment.
    #
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

    # An indentical, but non-blocking form of {#run}.
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
            rescue SystemExit, Interrupt => e 
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
        @read, @write = IO.pipe()
      end
 
  end

end
