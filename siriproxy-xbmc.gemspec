# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-xbmc"
  s.version     = "0.0.5" 
  s.authors     = ["brainwave9"]
  s.email       = [""]
  s.homepage    = ""
  s.summary     = %q{Siri Proxy Plugin to control XBMC}
  s.description = %q{This is a plugin that allows you to control XBMC using Siri}

  s.rubyforge_project = "SiriProxy-XBMC"

  s.files         = `git ls-files 2> /dev/null`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/* 2> /dev/null`.split("\n")
  s.executables   = `git ls-files -- bin/* 2> /dev/null`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "xbmc-client"
end
