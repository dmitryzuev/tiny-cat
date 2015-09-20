# ApplicationMailer
class ApplicationMailer < ActionMailer::Base
  default from: 'Tiny Cat <tiny-cat@test.com>'
  layout 'mailer'
end
