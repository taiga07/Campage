class ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def confirm
    @contact = Contact.new(contact_params)。
    if @contact.invalid?
      render :new
    end
  end

  def back
    @contact = Contact.new(contact_params)
    render :new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.send_mail(@contact).deliver_now
      flash.now[:notice] = "お問い合わせ内容を送信しました。"
      redirect_to root_path
    else
      render :error
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :name, :phone_number, :body)
  end
end
