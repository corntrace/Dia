## NEWS

### 1.1 (final)

* Dia::SandBox#run will exit the child process spawned if Dia::SandBoxException is raised ..

* Added some tests for Dia::SandBox.new#run\_with\_block ..  
  We ain't got full coverage but we're getting there.
  
* A person reported that ffi 0.6.0 does not work with dia ..  
  Supplied an explicit dependency on ffi 0.5.4 until I figure it out.
    
* You can run a block of ruby under a sandbox now but I had to change the order of arguments in the constructer ..  
  First argument is the profile, and (optionally) the second is the application path.  
  If you're running a block of ruby, you can forget about the second.
  
* I documented my methods!

