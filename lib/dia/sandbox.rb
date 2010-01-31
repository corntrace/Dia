module Dia
  
  class SandBox
  
    include Dia::CommonAPI
    
    attr_accessor :app_path
    attr_accessor :profile
    attr_accessor :pid
    
    def initialize app_path, profile
      @app_path = app_path
      @profile = profile
      @error = FFI::MemoryPointer.new :pointer
    end
    
    def run
      @pid = fork do
        unless (ret = sandbox_init(@profile, 0x0001, @error)) == 0
          raise StandardError, "Couldn't sandbox #{@app_path}, sandbox_init returned #{ret} with error message: '#{@error.get_pointer(0).read_string}'"
        end
        exec(@app_path)
      end
    end
  
  end
  
end