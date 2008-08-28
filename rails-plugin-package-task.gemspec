Gem::Specification.new do |s|
  s.name     = "rails-plugin-package-task"
  s.version  = "0.1"
  s.date     = "2008-08-27"
  s.summary  = "Automates the publishing of Rail plug-ins"
  s.email    = "mandhro@yahoo.com"
  s.homepage = "http://roxml.rubyforge.org/"
  s.description = "Designed to automate the publishing of Rail plug-ins. Extracted from ROXML CVS."
  s.has_rdoc = true
  s.author   = "Zak Mandhro"
  s.files    = ["MIT-LICENSE",
        "Rakefile",
        "README", 
        "rails-plugin-package-task.gemspec", 
        "lib/rails_plugin_package_task.rb"]
  s.require_path = 'lib'
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README"]
end
