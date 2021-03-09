class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    I18n.with_locale(I18n.locale) do
      mail to: user.email, subject: t("account_activations.subject")
    end
  end

  def password_reset user
    @user = user
    I18n.with_locale(I18n.locale) do
      mail to: user.email, subject: t("password_reset.subject")
    end
  end
end
