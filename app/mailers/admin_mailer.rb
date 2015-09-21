# Mailer for admin users
class AdminMailer < ApplicationMailer
  default to: proc { admin_emails }

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.order_placed_email.subject
  #
  def order_placed_email(todo_id)
    @todo_id = todo_id

    mail subject: "Кое-кто купил #{@todo_id}"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.order_failed_email.subject
  #
  def order_failed_email(user)
    @user = user

    mail subject: 'Не удалось купить кота'
  end

  def order_too_long_email
    mail subject: 'Слишком большая задержка при покупке'
  end

  private

  def admin_emails
    User.where(role: Role.find_by(name: 'admin')).pluck(:email)
  end
end
