module Dia
  module Functions
    extend(FFI::Library)
    ffi_lib(%w(system))
    attach_function(:sandbox_init, [ :pointer, :uint64, :pointer ], :int)
    attach_function(:sandbox_free_error, [ :pointer ], :void)  
  end
end
