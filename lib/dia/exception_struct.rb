module Dia
 # @attr_reader [String] klass     Returns Exception#class as a String.
 # @attr_reader [String] message   Returns Exception#message as a String.
 # @attr_reader [String] backtrace Returns Exception#backtrace as a String.
 class ExceptionStruct < Struct.new(:klass, :message, :backtrace)
 end
end
