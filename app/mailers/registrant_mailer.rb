class RegistrantMailer < ApplicationMailer
  require 'open-uri'

  default from: 'edmontononslaught@gmail.com'

  def registration_email(registrant_group, payment)
    @registrant_group = registrant_group
    @payment = payment
    registrant_group.each do |registrant|
      attachment_url = "http:#{URI.encode(registrant.system.cohort.attachment_url)}"
      attachments[URI(attachment_url).path.split('/').last] = open(attachment_url).read unless registrant.system.cohort.attachment_url.blank?
    end

    mail(to: @registrant_group[0].email, subject: 'Thanks for registering for Onslaught!')
  end
end
