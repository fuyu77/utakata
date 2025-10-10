# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: '短歌投稿サイトUtakata <utakatanka@gmail.com>',
          reply_to: 'utakatanka@gmail.com'
  layout 'mailer'
end
