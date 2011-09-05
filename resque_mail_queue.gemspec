# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lib/resque_mail_queue"

Gem::Specification.new do |s|
  s.name        = "resque_mail_queue"
  s.version     = Resque::MailQueue::VERSION
  s.authors     = ["Scott Watermasysk"]
  s.email       = ["scottwater@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "resque_mail_queue"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

	s.add_dependency 'actionmailer', '~> 3.0.0'
	s.add_dependency 'resque', '>= 1.1.0'
	s.add_development_dependency 'resque_spec', '>= 0.7.0'


  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
