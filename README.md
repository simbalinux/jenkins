Jenkins Environment
===================

Understanding Jenkins & Related Technologies
********************************************

1. What is Jenkins?
 * open source app written in java
 * Written by Kohsuke Kawaguchi
 * Massive community support
 * Numerous plugins for various tasks
 * Used for routine development cycle functions

2. Understanding Developement Stages
 * Feature branch forked from develop branch
 * Code added/modified and hten build/test is executed against it 
 * On success, the code is merged to the develop branch
 * More builds/tests are executed against the develop branch including integration tests
 * On success, the code is merged to the master branch 
 * A tag is created and optionally a package is prepared for development

3. What you will need
  * git binary installation (package manager e.g yum/apt)
  * github account for adding data
  * create a local ssh key pair & add the pub key to our github account
  * setting up a dedicated storage for jenkins (disaster recovery, we will use Terraform)
  * installing jre locally on jenkins master

 

https://learning.oreilly.com/videos/practical*jenkins/9781788398749
