module Dia
  
  module Profiles
    extend FFI::Library
    ffi_lib('sandbox')
    
    NO_INTERNET                    = attach_variable(:kSBXProfileNoInternet, :string).read_string
    NO_NETWORKING                  = attach_variable(:kSBXProfileNoNetwork, :string).read_string
    NO_FILESYSTEM_WRITE            = attach_variable(:kSBXProfileNoWrite, :string).read_string
    NO_FILESYSTEM_WRITE_EXCEPT_TMP = attach_variable(:kSBXProfileNoWriteExceptTemporary, :string).read_string
    NO_OS_SERVICES                 = attach_variable(:kSBXProfilePureComputation, :string).read_string
    
  end
  
end
    