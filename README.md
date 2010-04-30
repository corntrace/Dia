## "Dia"

"Dia" allows you to sandbox an application or block of ruby on the OSX platform by restricting what access to 
Operating System resources they can have.  

## What restrictions can you apply?  

Restrictions are applied through a "Profile" that is the first argument to `Dia::Sandbox.new`.  
There are five profiles in total that you can choose from out-of-the-box:

* No internet access  
  Using the profile Dia::Profiles::NO_INTERNET.

* No network access of any kind  
  Using the profile Dia::Profiles::NO_NETWORKING.

* No file system writes
  Using the profile Dia::Profiles::NO_FILESYSTEM_WRITE.

* No file system writes, excluding writing to /tmp  
  Using the profile Dia::Profiles::NO_FILESYSTEM_WRITE_EXCEPT_TMP.
  
* No OS services at all(No internet, No Networking, No File I/O)  
  Using the profile Dia::Profiles::NO_OS_SERVICES.

_See Below_ for examples.

## How it is done
It uses the FFI library, and the features exposed by the sandbox header on OSX.

## Examples

**Running FireFox under a sandbox**

This example demonstrates how you would sandbox an application, in this example, 'FireFox'.  
If you try this example yourself, you will see that FireFox cannot visit any websites on the internet.

    require 'rubygems'
    require 'dia'

    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_INTERNET, "/Applications/Firefox.app/Contents/MacOS/firefox-bin")
    sandbox.run
    puts "Launched #{sandbox.app} with a pid of #{sandbox.pid} using the profile #{sandbox.profile}"

**Running Ruby under a sandbox**

This example demonstrates how you would sandbox a block of ruby code.  
In this example, the block of ruby code tries to access the internet but the profile(Dia::Profiles::NO_INTERNET)  
doesn't allow this block of ruby to contact the internet.

    require 'rubygems'
    require 'dia'
    require 'net/http'
    require 'open-uri'
    
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_INTERNET) do
      open(URI.parse('http://www.google.com')).read
    end
    sandbox.run
    
**Terminating a sandbox**

Sometimes we might want to stop a sandbox from running any longer. `Dia::Sandbox#terminate` is provided to 
terminate a sandbox - in this example, FireFox is running under a sandboxed environment and terminated after 
running for 5 seconds.

    require 'rubygems'
    require 'dia'
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_INTERNET, "/Applications/Firefox.app/Contents/MacOS/firefox-bin")
    sandbox.run
    sleep(5)
    sandbox.terminate
    
**Checking if a sandbox is alive**

If you need to check if a sandbox you have spawned is still running, you can use the `Dia::Sandbox#running?` method.

    require 'rubygems'
    require 'dia'
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES) do
      sleep(20)
    end
    
    sandbox.run
    puts sandbox.running? # => true

## Install

It's available at gemcutter: 

    gem install dia

## License(MIT)

 Copyright (c) 2010 Robert Gleeson   
  
 Permission is hereby granted, free of charge, to any person  
 obtaining a copy of this software and associated documentation  
 files (the "Software"), to deal in the Software without  
 restriction, including without limitation the rights to use,  
 copy, modify, merge, publish, distribute, sublicense, and/or sell  
 copies of the Software, and to permit persons to whom the  
 Software is furnished to do so, subject to the following  
 conditions:  

 The above copyright notice and this permission notice shall be  
 included in all copies or substantial portions of the Software.  

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,  
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES  
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND  
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT  
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,  
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING  
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR  
 OTHER DEALINGS IN THE SOFTWARE.  
