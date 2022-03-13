json.array! @users do |user|
  json.partial! 'api/v1/professors/users/info', user: user
end
