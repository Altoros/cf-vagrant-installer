require 'rake'

desc "Init git submodules and clone required repos"
task :bootstrap do
  print "==> Init Git submodules"
  `git submodule update --init --recursive`
end
