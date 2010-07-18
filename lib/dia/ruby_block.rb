module Dia

  class RubyBlock

    require('io/wait') 
    require('stringio') 
    include Dia::SharedFeatures

    # @return  [Fixnum]  Returns the Process ID(PID) of the last child process that was
    #                    used to execute a sandbox.
    attr_reader :pid

    # @param  [String] Profile Accepts one of five profiles which can be found
    #                          under the {Dia::Profiles} module.
    #
    # @param  [Proc]   Block   Accepts a block or Proc object as its second argument.
    #
    # @raise  [ArgumentError]  It will raise an ArgumentError if a profile and block 
    #                          isn't supplied to the constructor
    #
    # @return [Dia::RubyBlock] Returns an instance of Dia::RubyBlock.
    def initialize(profile, &block)
      raise(ArgumentError, "It is required that a block be passed to the constructor.\n" \
                           "Please consult the documentation.") unless block_given?
      @profile         = profile
      @proc            = block
      @rescue          = false
      @redirect_stdout = false
      @pipes           = {}
    end


    # When the "capture stdout" feature is enabled, this method will return the contents
    # of the standard output stream for the child process used to execute your sandbox.
    #
    # @return [String]       Returns the contents of stdout.   
    #                        Returns nil when no data is available on stdout, or when the 
    #                        "capture stdout" feature is disabled.
    #
    # @see #redirect_stdout= This feature is disabled by default. See how to enable it.
    #   
    def stdout
      if pipes_readable?(@pipes[:stdout_reader], @pipes[:stdout_writer])
        @pipes[:stdout_writer].close
        @stdout = @pipes[:stdout_reader].read
        @pipes[:stdout_reader].close
      end
      @stdout
    end

    # This method can enable or disable a feature that will capture standard output
    # in the child process that is spawned to execute a sandbox.
    #
    # @param  [Boolean] Boolean Accepts a true(-ish) or false(-ish) value.
    # @return [Boolean] Returns the calling argument.
    # @see    #stdout   See #stdout for accessing the contents of stdout.
    def redirect_stdout=(boolean)
      @redirect_stdout = boolean
    end

    # This method will tell you if standatd output is being redirected in the child
    # process used to execute your sandbox.
    #
    # @see    #redirect_stdout=   See how to enable the "redirect stdout" feature.
    #
    # @return [Boolean] Returns true or false.
    def redirect_stdout?
      !!@redirect_stdout
    end

    # This method will tell you if an exception has been raised in the child process
    # used to execute your sandbox.   
    # The "capture exception" feature must be enabled for this method to ever
    # return true. 
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

    # This method can enable or disable a feature that will try to capture 
    # raised exceptions in the child process that is spawned to execute a sandbox.
    #
    # @param  [Boolean] Boolean Accepts a true(-ish) or false(-ish) value. 
    #
    # @return [Boolean] Returns the calling argument.
    #
    # @see    #exception See #exception for information on how to access 
    #                    the data of an exception raised in your sandbox.
    #
    # @since 2.0.0
    def rescue_exception=(boolean)
      @rescue = boolean
    end

    # When the "capture exceptions" feature is enabled and an exception has been raised in
    # the child process used to execute your sandbox, this method will return a subclass
    # of Struct whose attributes represent the exception data. 
    #
    # Every call {#run} or {#run_nonblock} will reset the instance variable referencing the
    # object storing exception data to nil.
    # 
    # @return [Dia::ExceptionStruct, nil] Returns an instance of {Dia::ExceptionStruct} or nil 
    #                                     when there is no exception available.  
    #
    # @see #rescue_exception=             The "capture exception" feature is disabled by default.  
    #                                     See how to enable it.
    #
    # @see Dia::ExceptionStruct           The documentation for Dia::ExceptionStruct.
    #
    # @since 1.5
    def exception
      if pipes_readable?(@pipes[:exception_reader], @pipes[:exception_writer]) 
        @pipes[:exception_writer].close
        @e = ExceptionStruct.new *Marshal.load(@pipes[:exception_reader].read).values_at(:klass, 
                                                                                         :message, 
                                                                                         :backtrace)
        @pipes[:exception_reader].close
      end
      @e
    end

    # The run method will spawn a child process to execute the block supplied to the constructer 
    # in a sandbox.   
    # This method will block. See {#run_nonblock} for the non-blocking form of
    # this method.
    #
    # @param  [Arguments] Arguments   A variable amount of arguments that will 
    #                                 be passed onto the block supplied to the 
    #                                 constructer. Optional.
    #
    # @raise  [SystemCallError]       It may raise a number of subclasses of SystemCallError 
    #                                 in a child process if a sandbox violates imposed 
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
      launch(*args) 

      # parent ..
      _, @exit_status = Process.wait2(@pid)
      @pid
    end

    # An identical, but non-blocking form of {#run}.
    def run_nonblock(*args)  
      launch(*args)

      @exit_status = Process.detach(@pid)
      @pid
    end

    private
      # @api private
      def launch(*args)
        @e = @stdout = nil
        close_pipes_if_needed
        open_pipes_if_needed

        @pid = fork do
          redirect(:stdout) if @redirect_stdout
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
            else
            ensure
              write_stdout_to_pipe_if_needed
              close_pipes_if_needed
            end
          else
            begin
              initialize_sandbox
              @proc.call(*args)
            ensure
              write_stdout_to_pipe_if_needed
              close_pipes_if_needed
            end
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
      def write_stdout_to_pipe_if_needed
        if @redirect_stdout
          $stdout.rewind
          @pipes[:stdout_reader].close
          @pipes[:stdout_writer].write($stdout.read)
          @pipes[:stdout_writer].close
        end
      end

      # @api private
      def close_pipes_if_needed
        @pipes.each do |key, pipe|
          if !pipe.nil? && !pipe.closed?
            pipe.close
          end
        end
      end

      # @api private
      def open_pipes_if_needed
        @pipes[:exception_reader], @pipes[:exception_writer] = IO.pipe if @rescue
        @pipes[:stdout_reader]   , @pipes[:stdout_writer]    = IO.pipe if @redirect_stdout
      end

      # @api private
      def write_exception(e)
        @pipes[:exception_writer].write(Marshal.dump({ :klass     => e.class.to_s    ,
                                    :backtrace => e.backtrace.join("\n"),
                                    :message   => e.message.to_s }) )
      end

      # @api private
      def pipes_readable?(reader, writer)
        (reader && writer) && 
        (!reader.closed? && !writer.closed?) && 
        (reader.ready?)
      end

      # @api private
      def redirect(symbol)
        level    = $VERBOSE
        $VERBOSE = nil
        if symbol == :stdout 
          $stdout  = StringIO.new
          Object.const_set(:STDOUT, $stdout)
        else
          # implement me
        end
        $VERBOSE = level
      end
    
  end

end
