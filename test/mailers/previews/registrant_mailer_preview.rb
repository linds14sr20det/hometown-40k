# Preview all emails at http://localhost:3000/rails/mailers/registrant_mailer
class RegistrantMailerPreview < ActionMailer::Preview

  def registration_email
    registrant = Registrant.first
    registrant_group = Registrant.where(:email => registrant.user.email).limit(2)
    RegistrantMailer.registration_email(registrant_group)
  end
end
