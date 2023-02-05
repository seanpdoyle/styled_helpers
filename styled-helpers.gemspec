require_relative "lib/styled_helpers/version"

Gem::Specification.new do |spec|
  spec.name = "styled_helpers"
  spec.version = StyledHelpers::VERSION
  spec.authors = ["Sean Doyle"]
  spec.email = ["sean.p.doyle24@gmail.com"]
  spec.homepage = "https://github.com/seanpdoyle/styled_helpers"
  spec.summary = "Extend Action View helpers"
  spec.description = spec.summary
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/seanpdoyle/styled_helpers"
  spec.metadata["changelog_uri"] = "https://github.com/seanpdoyle/styled_helpers/blob/main/CHANGELOG.md"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 6.1.3.1"
end
