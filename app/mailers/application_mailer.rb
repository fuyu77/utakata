# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com',
          reply_to: 'utakatanka@gmail.com'
  layout 'mailer'
end
