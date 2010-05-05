## "Dia"

"Dia" allows you to sandbox an application or block of ruby on the OSX platform by restricting what access to 
Operating System resources they can have.  

## How it is done
It uses the FFI library, and the features exposed by the sandbox header on OSX.

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
In this example, the block of ruby code tries to access the internet but the profile(Dia::Profiles::NO_INTERNET) doesn't 
allow this block of ruby to contact the internet and an exception is raised(in a child process - your app will continute to
execute normally).

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


**Collecting the exit status of a sandbox**  

The sandbox environment is run in a child process, and you can collect its 
exit status through the #exit_status() method. This method is only available
from 0.5.pre onwards.

    require 'rubygems'
    require 'dia'
    sandbox = Dia::Sandbox.new(Dia::Profiles::NO_OS_SERVICES) do
      exit(10)
    end

    sandbox.run()
    sandbox.exit_status() # => 10


.. Please see the yardoc [documentation](http://yardoc.org/docs/robgleeson-Dia) for more in-depth coverage of these methods, 
in particular the documentation for the `Dia::Sandbox` class.

## Install

It's available at gemcutter: 

`gem install dia`

## Bugs

No known bugs right now. [Found a bug?](http://github.com/robgleeson/dia/issues).

## Contact

* IRC  
  irc.freenode.net/#flowof.info as 'robgleeson'

* Mail  
  rob [at] flowof.info

