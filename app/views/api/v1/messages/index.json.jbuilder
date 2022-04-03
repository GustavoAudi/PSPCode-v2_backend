# frozen_string_literal: true

json.messages @messages.each do |message|
  json.partial! 'api/v1/messages/info', message:
end
