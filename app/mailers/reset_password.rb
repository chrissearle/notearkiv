class ResetPassword < ActionMailer::Base
  default :from => "OCHS Arkiv <arkiv@ochs.no>"

  def reset_password(user, code)
    @user = user
    @url = "http://arkiv.ochs.no/login_once/#{code}"
    mail(:to => user.email, :subject => "Passord resett")
  end
end
