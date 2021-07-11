require "./lib/delocalize/version"

Gem::Specification.new do |s|
  s.name = "delocalize"
  s.version = Delocalize::VERSION

  s.authors = ["Clemens Kofler", "Nulogy Engineering"]
  s.summary = %q{Localized date/time and number parsing}
  s.description = %q{Delocalize is a tool for parsing localized dates/times and numbers.}
  s.license = "MIT"
  s.email = %q{info@nulogy.com}
  s.extra_rdoc_files = ["README.markdown"]
  s.files = Dir["{bin,lib}/**/*", "README*", "*LICENSE*"]
  s.homepage = %q{http://github.com/clemens/delocalize}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 5"
  s.add_development_dependency "timecop"
  s.add_development_dependency "simplecov"
end
