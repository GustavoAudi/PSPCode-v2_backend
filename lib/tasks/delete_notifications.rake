# rubocop:disable all
task delete_notifications: :environment do
  puts "You're about to delete notifications, the following actions will be performed: \n"
  puts "   * Destroy all the event_notifications in the system for every user \n"
  puts "   * Destroy all the message_notifications in the system for every user \n"
  puts "Are you sure you want to proceed? (type y/n)"
  if STDIN.gets.strip == 'y'
    MessageNotification.destroy_all
    EventNotification.destroy_all
    print "\n \n All the notifications were successfully deleted"
  else
    print 'No modifications were made'
  end
end
