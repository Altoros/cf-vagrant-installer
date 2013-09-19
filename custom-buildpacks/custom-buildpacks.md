# Overview
Now you can test external and your own buildpacks with cf-vagrant-installer

Why this? Why now?
How does it help?
Who can benefit?
What are the use cases?

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
