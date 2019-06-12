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

4. Steps to get up the environment
  * "vagrant up jenkins" 
    - Will deploy jenkins master w/ NGINX reverse proxy using Puppet
    * During setup/deploy get IP address of guest VM (jenkins) add your HOST /etc/hosts file (to obtain the Jenkins UI access)
    * Open browser on HOST machine and enter "http://jenkins" login will be "admin/admin" can be changed in groovy scripts. 
    * READ the Vagrantfile comments for explanation of provision process of files and scripts that are executed.
  * Manual Steps:
    * Copy the public key created in $HOME/.ssh into your github account under deploy keys
    * Login to Jenkins UI and go to "credentials" and add a ssh private key credential us the private key in $HOME on Jenkins.
    * Login to Jenkins UI and click on the job "python-project-new" and attach the private key credential you added.
    * Now run the test job and you will notice success & cleanup will occur in output log.
    * The Python Test job is already part of the Puppet provisioning and made avaialable post install. 

https://learning.oreilly.com/videos/practical*jenkins/9781788398749
