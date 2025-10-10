# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'utakatanka@gmail.com',
          reply_to: 'utakatanka@gmail.com'
  layout 'mailer'
end
