# frozen_string_literal: true

guard "minitest" do
  watch(%r{^test/(.*)\/?(.*)_test\.rb$})
  watch(%r{^lib/(.*/)?([^/]+)\.rb$}) { |m| "test/#{m[1]}#{m[2]}_test.rb" }
  watch(%r{^app/(.*/)?([^/]+)\.rb$}) { |m| "test/#{m[1]}#{m[2]}_test.rb" }
  watch(%r{^test/application_system_test_case\.rb$}) { "test/system" }
  watch(%r{^test/test_helper\.rb$}) { "test" }
  watch("config/routes.rb") { "test/controllers/routing_test.rb" }
end
