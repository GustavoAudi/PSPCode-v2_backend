# frozen_string_literal: true

json.statuses statuses.each do |status|
  json.partial! 'api/v1/statuses/info', status: status
end
