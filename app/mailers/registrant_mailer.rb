class RegistrantMailer < ApplicationMailer
  require 'open-uri'

  default from: 'hometown40k@gmail.com'

  def registration_email(registrant_group)
    @registrant_group = registrant_group
    registrant = registrant_group.first
    attachment_url = "#{URI.encode(registrant.system.cohort.attachment_url)}"
    attachments[URI(attachment_url).path.split('/').last] = open(attachment_url).read unless registrant.system.cohort.attachment_url.blank?

    mail(to: @registrant_group[0].user.email, subject: 'Thanks for registering for Hometown 40k!')
  end
end
