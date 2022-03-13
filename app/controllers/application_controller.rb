class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :reload_rails_admin, if: :rails_admin_path?

  private

  def reload_rails_admin
    models = %w(Phase Course PspProcess Professor Project User CourseProjectInstance)
    models.each do |model|
      RailsAdmin::Config.reset_model(model)
    end
    RailsAdmin::Config::Actions.reset

    load("#{Rails.root}/config/initializers/rails_admin.rb")
  end

  def rails_admin_path?
    controller_path =~ /rails_admin/ && Rails.env.development?
  end
end
