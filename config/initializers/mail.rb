ActionMailer::Base.register_interceptor(SendGrid::MailInterceptor)

ActionMailer::Base.smtp_settings = {
  user_name: ENV['sendgrid_username'],
  password: ENV['sendgrid_password'],
  domain: 'itsrudolph.com',
  address: 'smtp.sendgrid.net',
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}