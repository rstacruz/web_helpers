Gem::Specification.new do |s|
  s.name = "web_helpers"
  s.version = "0.0.1"
  s.summary = %{Simple web helpers.}
  s.description = %Q{Web helpers for Rails/Sinatra.}
  s.authors = ["Rico Sta. Cruz"]
  s.email = ["rico@sinefunc.com"]
  s.homepage = "http://github.com/rstacruz/web_helpers"
  s.files = `git ls-files`.strip.split("\n")
  s.executables = Dir["bin/*"].map { |f| File.basename(f) }
end
