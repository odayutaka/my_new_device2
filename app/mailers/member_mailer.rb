class MemberMailer < ApplicationMailer
  default from: 'hogehoge@example.com'

  def welcome_email(member)
    @member = public_member
    mail(
      to: @member.email,
      subject: "会員登録が完了しました。"
    ) do |format|
      format.text
    end
  end
end