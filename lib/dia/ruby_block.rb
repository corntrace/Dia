module Dia

  class RubyBlock

    require('io/wait')  
    include Dia::SharedFeatures

    # @return  [Fixnum]  Returns the Process ID(PID) of the last child process that ran
    #                    in a sandboxed environment.  
    attr_reader :pid

    # @param  [String] Profile Accepts one of five profiles which can be found
    #                          under the {Dia::Profiles} module.
    #
    # @param  [Proc]   Block   Accepts a block or Proc object as its second argument.
    #
    # @raise  [ArgumentError]  It may raise an ArgumentError if a block isn't supplied to the
    #                          constructor.
    #
    # @return [Dia::RubyBlock] Returns an instance of Dia::RubyBlock.
    def initialize(profile, &block)
      raise(ArgumentError, "It is required that a block be passed to the constructor.\n" \
                           "Please consult the documentation.") unless block_given?
      @profile = profile
      @proc   = block
      @rescue  = false
    end


    # This method will tell you if a sandbox executed in a child process 
    # has raised an exception or not by returning a boolean. 
    # 
    # @see    #rescue_exception= See #rescue_exception= for enabling the capture
    #                            of raised exceptions in your sandbox.
    #
    # @see    #exception         See the #exception method for accessing an 
    #                            exception raised in your sandbox.
    #
    # @return [Boolean]          Returns true or false.
    def exception_raised?
      !!exception
    end

    # This method will tell you if the {#rescue_exception=} feature is enabled by
    # returning a boolean.
    #
    # @see    #rescue_exception= See #rescue_exception= for enabling the capture
    #                            of raised exceptions in your sandbox.
    #
    # @see    #exception         See the #exception method for accessing an 
    #                            exception raised in your sandbox.
    #
    # @return [Boolean] Returns true or false.
    # @since  2.0.0
    def rescue_exception?
      !!@rescue
    end

    # This method can enable or disable a feature that will capture 
    # exceptions that are raised in your sandbox.  
    # This feature is useful because your sandbox is executed inside a 
    # child process.  
    # Communicating data between the parent process and child process can be 
    # cumbersome at times - this feature tries to alleviate that.
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

    # This method will return an OpenStruct object representing the attributes
    # of an exception object raised in your sandbox.
    #
    # When this method is being used in conjuction with {#run_nonblock}, you
    # may need to call sleep for a duration of 1 to 2 seconds before the
    # exception will be available to the parent process.
    # 
    # @return [OpenStruct, nil] Returns an OpenStruct instance representing 
    #                           the attributes of the exception object raised 
    #                           in your sandbox or nil when there is no exception 
    #                           available.  
    #                           Every call to {#run} or {#run_nonblock} will 
    #                           reset the instance variable referencing 
    #                           an exception to nil.
    #
    # @see #rescue_exception=   This feature is disabled by default.  
    #                           See how to enable it.
    #
    # @since 1.5
    def exception
      if (!@read.nil? && !@write.nil?) && 
         (!@read.closed? && !@write.closed?) && (@read.ready?)
        @write.close
        @e = OpenStruct.new(Marshal.load(@read.read))
        @read.close
      end
      @e
    end

    # The run method will execute a block supplied to the constructer in a child process
    # under a sandboxed environment.   
    # This method will block. See {#run_nonblock} for the non-blocking form of
    # this method.
    #
    # @param  [Arguments] Arguments   A variable amount of arguments that will 
    #                                 be passed onto the block supplied to the 
    #                                 constructer. Optional.
    #
    # @raise  [SystemCallError]       It may raise a number of subclasses of SystemCallError 
    #                                 in a child process if your sandbox violates imposed 
    #                                 restrictions.   
    #
    # @raise  [Dia::SandboxException] It may raise 
    #                                 {Dia::Exceptions::SandboxException}
    #                                 in a child process if it was not possible
    #                                 to initialize a sandbox environment. 
    #
    # @return [Fixnum]                The Process ID(PID) that the sandbox has
    #                                 been launched under.
    def run(*args)
      if @rescue
        initialize_streams      
      end

      launch(*args) 

      # parent ..
      _, @exit_status = Process.wait2(@pid)
      @pid
    end

    # An identical, but non-blocking form of {#run}.
    def run_nonblock(*args)
      if @rescue
        initialize_streams
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
          if @rescue
            begin
              initialize_sandbox
              @proc.call(*args)
            rescue SystemExit, SignalException, NoMemoryError => e 
              raise(e)
            rescue Exception => e
              begin     
                write_exception(e) 
              rescue SystemExit, SignalException, NoMemoryError => e
                raise(e)
              rescue Exception => e
                write_exception(e)
              end
            ensure
              @write.close
              @read.close
            end
          else
            initialize_sandbox
            @proc.call(*args)
          end
        end
      end

      # @api private
      def initialize_sandbox
        if Dia::Functions.sandbox_init(FFI::MemoryPointer.from_string(@profile),
                                       0x0001, 
                                       err = FFI::MemoryPointer.new(:pointer)) \
                                       == -1

          raise(Dia::Exceptions::SandboxException, "Failed to initialize sandbox" \
                                                   "(#{err.read_pointer.read_string})")
        end
      end

      # @api private
      def initialize_streams
        if ( (!@read.nil? && !@write.nil?) && 
             (!@read.closed? && !@write.closed?) )
          @read.close
          @write.close
        end
        @read, @write = IO.pipe
      end

      # @api private
      def write_exception(e)
        @write.write(Marshal.dump({ :klass     => e.class.to_s    ,
                                    :backtrace => e.backtrace.join("\n"),
                                    :message   => e.message.to_s }) )
      end

  end

end
