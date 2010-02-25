## NEWS

* Mac OSX 10.5 reported as working! (Bug fix)  
  Many thanks to Josh Creek for reporting and helping me debug this bug.
* Use ffi\_lib() to explicitly load the dynamic library "sandbox", or "System"
* Depend explicitly on FFI v0.6.2
* Dia::Sandbox#run accepts a variable amount of arguments that will be passed onto the block supplied to the constructer.

### 1.3
* Added Dia::Sandbox#running? to check if a process running a sandbox is alive or not.
* Dia::Sandbox only exposes its instance variables through getters now. No more setters.
* Dia::Sandbox#app_path is now Dia::Sandbox#app
* Removed run\_with\_block in favor of passing a block to the constructer. Dia::Sandbox#run is used to execute a block or an application now, 
  but only one or the other may be supplied to the constructer.
* Removed Dia::SandBox in favor of Dia::Sandbox.
* Added "has_rdoc = 'yard'" to the gem spec.
* Added ".yardopts" to the list of files in the gem spec.
* SandBoxException becomes SandboxException.

### 1.2
* I've decided to use Dia::Sandbox instead of Dia::SandBox but it won't be removed until 1.3 .. (Deprecated for 1.2)
* I've decided to remove the explicit exit() call in a sandbox spawned with run\_with\_block .. (Introduced in 1.1 Final)
* Added Dia::Sandbox#terminate for terminating a sandbox.
* Process.detach(*sandbox pid*) is used in the parent process that spawns a sandbox to avoid collecting zombies ..

### 1.1 (final)
* Dia::SandBox#run\_with\_block will exit the child process spawned by itself incase the user forgets to ..

* Added some tests for Dia::Sandbox.new#run\_with\_block ..  
  We ain't got full coverage but we're getting there.
  
* A person reported that ffi 0.6.0 does not work with dia ..  
  Supplied an explicit dependency on ffi 0.5.4 until I figure it out.
    
* You can run a block of ruby under a sandbox now but I had to change the order of arguments in the constructer ..  
  First argument is the profile, and (optionally) the second is the application path.  
  If you're running a block of ruby, you can forget about the second.
  
* I documented my methods!

