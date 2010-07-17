suite('Dia::ExceptionStruct') do

  setup do 
    @sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) do
      raise(RuntimeError, 'Example')
    end
    @sandbox.rescue_exception = true
  end
  
  suite('#klass') do
    exercise('@rescue is set to true. A RuntimeError is raised in a sandbox. ') do
      @sandbox.run
    end
    
    verify('#klass returns RuntimeError as a String') do
      @sandbox.exception.klass == 'RuntimeError'
    end
  end

  suite('#message') do
    exercise('@rescue is set to true. A RuntimeError is raised in a sandbox. ') do
      @sandbox.run
    end

    verify("#message returns 'Example' as a String") do
      @sandbox.exception.message == 'Example'
    end
  end

  suite('#backtrace') do
    exercise('@rescue is set to true. A RuntimeError is raised in a sandbox. ') do
      @sandbox.run
    end

    verify('#backtrace returns a string') do
      @sandbox.exception.backtrace.class == String
    end
  end

end
