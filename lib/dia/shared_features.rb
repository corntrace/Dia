module Dia

  module SharedFeatures

    # The exit_status method will return the exit status of your sandbox.  
    # This method *will* block until the child process(your sandbox) exits.
    #
    # @return [Fixnum, nil] Returns the exit status of your sandbox as a 
    #                       Fixnum.  
    #                       Returns nil if #run or #run_nonblock has not
    #                       been called yet.
    # @since 1.5
    def exit_status()
      unless @exit_status.nil?
        Thread === @exit_status ? @exit_status.value().exitstatus() : 
                                  @exit_status.exitstatus()
      end
    end

    # The terminate method will send the SIGKILL signal to your sandbox.
    #
    # @raise  [SystemCallError] It may raise a number of subclasses of 
    #                           SystemCallError if a call to Process.kill 
    #                           was unsuccessful…
    #
    # @return [Fixnum, nil]     Returns 1 when successful.     
    #                           Returns nil if #run or #run_nonblock has not 
    #                           been called yet. 
    def terminate()
      ret = Process.kill('SIGKILL', @pid) unless @pid.nil?
      # precaution against the collection of zombie processes.
      @exit_status = Process.detach(@pid) if running? 
      ret
    end
    
    # This method will tell you whether or not your sandbox is still running.
    #
    # @raise  [SystemCallError] Raises a subclass of SystemCallError if 
    #                           you do not have permission to send a signal
    #                           to the process running in a sandboxed 
    #                           environment.
    #
    # @return [Boolean,nil]     Returns true when the sandbox is running 
    #                           and false if it is not.  
    #                           Returns nil if #run or #run_nonblock has 
    #                           not been called yet.
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
