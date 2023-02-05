require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module StyledHelpers
end

require "styled_helpers/engine" if defined?(Rails::Engine)
