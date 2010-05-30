module Dia

  module SharedFeatures

    # The exit_status method will return the exit status of the child process 
    # that has been run in a sandbox.
    # This method *will* block until the child process exits.
    #
    # @return [Fixnum, nil] Returns the exit status of the process that ran
    #                       under a sandbox.
    #                       Returns nil if #run() or #run_nonblock() has not 
    #                       been called yet, or if the process stopped
    #                       abnormally(ie: through SIGKILL, or #terminate).
    # @since 1.5
    def exit_status()
      unless @exit_status.nil?
        Thread === @exit_status ? @exit_status.value().exitstatus() : 
                                  @exit_status.exitstatus()
      end
    end

    # The terminate method will send SIGKILL to a process running in a sandbox.
    # By doing so, it effectively terminates the sandbox.
    #
    # @raise  [SystemCallError] It may raise a number of subclasses of 
    #                           SystemCallError if a call to Process.kill 
    #                           was unsuccessful…
    #
    # @return [Fixnum, nil]     It will return 1 when successful, and 
    #                           it will return nil if #run() or #run_nonblock() 
    #                           has not been called yet. 
    def terminate()
      Process.kill('SIGKILL', @pid) unless @pid.nil?
    end
    
    # The running?() method will return true if a sandboxed process is running, 
    # and false otherwise.  
    #
    # @raise  [SystemCallError] It may raise a subclass of SystemCallError if 
    #                           you do not have permission to send a signal
    #                           to the process running in a sandbox.
    #
    # @return [Boolean,nil]     It will return true if the sandbox is running 
    #                           and false if it is not.
    #                           It will return nil if #run or #run_nonblock has 
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
