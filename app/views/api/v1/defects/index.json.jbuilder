# frozen_string_literal: true

json.array! defects do |defect|
  json.partial! 'api/v1/defects/info', defect:
end
