## TODO

### 1.4
* Dia::Sandbox.run() doesn't use @app to launch a process, but uses @app\_path which was removed in 1.3
 * If you're going to run a block under a sandbox, make Dia::Sandbox#run accept *args so they may be passed onto the block.

### 1.3
* Remove link to experimental branch in gemspec before release
