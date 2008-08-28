require 'rake/gempackagetask'
require "rake/rdoctask"

spec = eval(IO.read("rails-plugin-package-task.gemspec"))

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

Rake::RDocTask.new do |rd|
  rd.rdoc_dir = "doc"
  rd.rdoc_files.include("lib/**/*.rb")
  rd.options = spec.rdoc_options
end