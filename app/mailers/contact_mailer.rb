class ContactMailer < ApplicationMailer

  def send_mail(contact)
    @contact = contact
    mail(
      to: ENV['TOMAIL'],  #どのメールアドレスに送るか
      subject: 'Campageからのお問い合わせ',
      )
  end

end
