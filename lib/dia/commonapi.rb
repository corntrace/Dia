require 'rubygems'
require 'ffi'

module Dia
  module CommonAPI
    extend FFI::Library
    ffi_lib(%w(sandbox system libSystem.B.dylib))
    attach_function :sandbox_init, [ :string, :int, :pointer ], :int
  end
end
