# Preview all emails at http://localhost:3000/rails/mailers/registrant_mailer
class RegistrantMailerPreview < ActionMailer::Preview

  def registration_email
    registrant = Registrant.first
    RegistrantMailer.registration_email(Array(registrant))
  end
end
