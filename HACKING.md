## Git policy

* "master" should always be in a _working state_, so no experimental code ..
* Pre releases should never be merged into "master", but should stay in experimental .. 
* The experimental branch is the _one and only_ gateway to being merged into master ..  
  So, if you're working on a feature, branch off from experimental, merge back into experimental, and when deemed stable experimental
  will be merged into master ..