# frozen_string_literal: true

begin
  ENV.update YAML.load(File.read('config/application.yml'))
rescue StandardError
  puts "You've to add a correct application.yml file"
end
