# Overview

Now you can test and distribute any buildpacks (3rd party, or your own) with cf-vagrant-installer

##### How does it help? 
It eliminates the need to run full blown Cloud Foundry deployment for trying/testing/validating/distributing your buildpack
or your application agains a specific buildpack

##### Who can benefit?
- Developers of custom buildpacks
- Developers of an application that requires a particular non-standard buildpack
- Anyone who wants to know if a Buildpack X would work on Cloud Foundry
- Software vendors who want to get their products (in the form of buildpacks) to more users - this offers

##### What are the use cases?
- Developing and testing buildpacks and custom buildbacks based applications
- Training: Getting anyone new to Cloud Foundry to try it out with any buildpack
- Marketing: Distribute your custom buildpacks (for example IBM Liberty) as a one click installer

##### Cloud Foundry documentation
- [Cloud Foundry buildpacks] (http://docs.cloudfoundry.com/docs/using/deploying-apps/buildpacks.html)
- [And what about Custom Buildpacks?] (http://docs.cloudfoundry.com/docs/using/deploying-apps/custom-buildpacks.html)

# Test an external buildpack
> Let's assume you already have CF running following [this] (https://github.com/Altoros/cf-vagrant-installer/blob/master/README.md) instructions

Install the buildpack

```
cd <your local cf-vagrant-installer repo folder>/custom-buildpacks
git clone https://github.com/heroku/heroku-buildpack-php.git
cd ..
rake cf:setup_custom_buildpacks
```

Then you can push any PHP application. Here is an example

```
git clone https://github.com/borovsky/cf-wordpress
cd cf-wordpress
cf push
```
