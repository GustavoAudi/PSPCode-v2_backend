json.id message.id
json.person do
  if message.sender.is_a? User
    json.partial! 'api/v1/users/info',
                  user: message.sender
  else
    json.partial! 'api/v1/professors/info',
                  professor: message.sender
  end
end
json.date message.created_at
json.message message.text
json.link message.file&.url
json.message_type message.message_type
