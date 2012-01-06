# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-xbmc"
  s.version     = "0.1.0" 
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
  # s.add_runtime_dependency "xbmc-client"

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, [">= 0.6.0"])
      s.add_runtime_dependency(%q<json>, [">= 1.4.5"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_runtime_dependency(%q<i18n>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 2.10.3"])
    else
      s.add_dependency(%q<httparty>, [">= 0.6.0"])
      s.add_dependency(%q<json>, [">= 1.4.5"])
      s.add_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 2.10.3"])
    end
  else
    s.add_dependency(%q<httparty>, [">= 0.6.0"])
    s.add_dependency(%q<json>, [">= 1.4.5"])
    s.add_dependency(%q<activesupport>, [">= 3.0.0"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 2.10.3"])
  end

end
