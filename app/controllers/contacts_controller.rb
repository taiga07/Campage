class ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end



  def confirm
    @contact = Contact.new(contact_params)  # newアクションから入力内容を受け取る。
    if @contact.invalid?  #バリデーションエラーが発生した場合trueを返す。
      render :new
    end
  end

  # 入力内容の変更をしたい場合、
  # backアクションを定義することでデータを残したまま戻れる。
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

  #送信完了画面を使用する場合。
  # def done
  # end

  private

  def contact_params
    params.require(:contact).permit(:email, :name, :phone_number, :body)
  end
end
