# Dia  
Through the use of technology found on Apple's Leopard and Snow Leopard 
operating systems, Dia can create dynamic and robust sandbox environments 
for applications and for blocks of ruby code. The Ruby API was designed to be 
simple, and a joy to use. I hope you feel the same way :-)

## Quick Example

* RubyBlock

        require('rubygems')
        require('dia')
        require('open-uri')

        sandbox = Dia::RubyBlock.new(Dia::Profiles::NO_INTERNET) do
          open('http://www.google.com')
        end

        sandbox.rescue_exception = true
        sandbox.run
        puts "Exception  : #{sandbox.exception.klass}"
        puts "Message    : #{sandbox.exception.message}"

* Application

        require('rubygems')
        require('dia')

        sandbox = Dia::Application.new(Dia::Profiles::NO_INTERNET,
                                       '/path/to/firefox')

        sandbox.run_nonblock 
        sandbox.terminate

## Documentation

* [API Documentation](http://yardoc.org/docs/robgleeson-Dia/)   
  Written using YARD, the API documentation makes a great reference.  
  *The API documentation linked is for the latest stable release*

* [Mailing list](http://groups.google.com/group/ruby-dia)   
  Troubleshoot your problems with other Dia users on the Google Groups mailing list.  

* Wiki documentation  
  *Work in progress*

## Supported Rubies.

The following Ruby implementations have had the test suite run against them, and
reported a 100% success rate.

* MRI
  * 1.8.7-p299
  * 1.9.1-p378
  * 1.9.2-rc1    
* REE
  * Ruby Enterprise Edition 2010.02 (1.8.7-p253)

MacRuby is not supported because it does not support Kernel.fork, and it won't add support
for fork anytime soon(if ever).  
JRuby has experimental support for fork, but I haven't tried it.
 
## Bugs  
Bug reports are _very_ welcome, and can be reported through the
[issue tracker](http://github.com/robgleeson/dia/issues).


