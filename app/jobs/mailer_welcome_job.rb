# frozen_string_literal: true

class MailerWelcomeJob < ApplicationJob
  queue_as :default

  def perform(user, generated_password)
    ApplicationMailer.welcome_email(user, generated_password).deliver_now
  end
end
