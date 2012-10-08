if Rails.env.development?

  require "mail"

  class DevelopmentMailInterceptor
    def self.delivering_email(message)
      if Rails.env.development?
        message.subject = "[#{Array(message.to).join(', ')}] #{message.subject}"
        message.to = Settings.all_mail_to
      end
    end
  end

  Mail.register_interceptor(DevelopmentMailInterceptor)

end
