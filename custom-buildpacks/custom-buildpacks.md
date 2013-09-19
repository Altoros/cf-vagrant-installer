# Overview

Now you can test any buildpacks (3rd party, or your own) with cf-vagrant-installer

How does it help? 
- It eliminates the need to run full blown Cloud Foundry deployment for trying/testing/validating/distributing your buildpack

Who can benefit?
- Developers of custom buildpacks
- Anyone who wants to know if a Buildpack X would work on Cloud Foundry
- Software vendors who want to get their products (in the form of buildpacks) to more users - this offers

What are the use cases?
- Developing and testing buildpacks
- Training: Getting anyone new to Cloud Foundry to try it out with any buildpack
- Marketing: Distribute your custom buildpacks (for example IBM Liberty) as a one click installer

What buildpacks are?
(http://docs.cloudfoundry.com/docs/using/deploying-apps/buildpacks.html)

And what about Custom Buildpacks?
(http://docs.cloudfoundry.com/docs/using/deploying-apps/custom-buildpacks.html)

# Test an external buildpack

- Download and configure cf-vagrant-installer
- `cd custom-buildpacks`
- `git clone https://github.com/heroku/heroku-buildpack-php.git`
- `cd ../test/fixtures/apps/`
- `git clone https://github.com/borovsky/cf-wordpress`
- `cd ../../../`
- `vagrant up`
- `vagrant ssh`
- `cd /vagrant`
- `rake cf:setup_custom_buildpacks`
- `cd test/fixtures/apps/cf-wordpress`
- `cf push`
