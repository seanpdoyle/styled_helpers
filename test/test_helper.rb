# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
require "rails/test_help"
require "capybara/minitest"

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_paths)
  ActiveSupport::TestCase.fixture_paths << File.expand_path("fixtures", __dir__)
  ActionDispatch::IntegrationTest.fixture_paths = ActiveSupport::TestCase.fixture_paths
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_paths.last + "/files"
  ActiveSupport::TestCase.fixtures :all
end

class ActionView::TestCase < ActiveSupport::TestCase
  include Capybara::Minitest::Assertions

  def page
    @page ||= Capybara.string(rendered)
  end
end
