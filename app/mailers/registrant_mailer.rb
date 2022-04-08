class RegistrantMailer < ApplicationMailer
  require 'open-uri'

  default from: 'noreply@hometown40k.com'

  def registration_email(registrant_group)
    @registrant_group = registrant_group
    registrant = registrant_group.first
    unless registrant.system.cohort.attachment_url.blank?
      attachment_url = "#{URI.encode(registrant.system.cohort.attachment_url)}"
      attachments[URI(attachment_url).path.split('/').last] = open(attachment_url).read
    end
    mail(to: @registrant_group[0].user.email, subject: 'Thanks for registering for Hometown 40k!')
  end
end
