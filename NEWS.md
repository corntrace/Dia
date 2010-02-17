## NEWS
### 1.2.pre
* I've decided to remove the explicit exit() call in a sandbox spawned with run\_with\_block .. (Introduced in 1.1 Final)
* Added Dia::SandBox#terminate for terminating a sandbox.
* Process.detach(*sandbox pid*) is used in the process that spawns a sandbox to avoid collecting zombies ..

### 1.1 (final)
* Dia::SandBox#run\_with\_block will exit the child process spawned by itself incase the user forgets to ..

* Added some tests for Dia::SandBox.new#run\_with\_block ..  
  We ain't got full coverage but we're getting there.
  
* A person reported that ffi 0.6.0 does not work with dia ..  
  Supplied an explicit dependency on ffi 0.5.4 until I figure it out.
    
* You can run a block of ruby under a sandbox now but I had to change the order of arguments in the constructer ..  
  First argument is the profile, and (optionally) the second is the application path.  
  If you're running a block of ruby, you can forget about the second.
  
* I documented my methods!

