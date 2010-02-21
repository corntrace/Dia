## "Dia"

"Dia" allows you to sandbox applications on the OSX platform by restricting what access to Operating System resources they can have.  

## What restrictions can you apply?  

* No internet access.
* No network access of any kind.
* No file system writes.
* No file system writes, exlcuding writing to /tmp.
* A complete lockdown of Operating System resources.

## How it is done
FFI, and the C header "sandbox.h" (found on OSX).

## Examples

### Example 1 (Running an application under a sandbox)

    require 'rubygems'
    require 'dia'

    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_INTERNET, "/Applications/Firefox.app/Contents/MacOS/firefox-bin")
    sandbox.run
    puts "Launched #{sandbox.app} with a pid of #{sandbox.pid} using the profile #{sandbox.profile}"

### Example 2 (Running ruby under a sandbox)

    require 'rubygems'
    require 'dia'
    require 'open-uri'
    
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES) do
      open(URI.parse('http://www.google.com')).read
    end
    sandbox.run
    
### Example 3 (Terminating a sandbox)

    require 'rubygems'
    require 'dia'
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_INTERNET, "/Applications/Firefox.app/Contents/MacOS/firefox-bin")
    sandbox.run
    sleep(5)
    sandbox.terminate
    
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
