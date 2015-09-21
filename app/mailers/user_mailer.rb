# Mailer to perform user-related emails
class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.order_placed_email.subject
  #
  # user - User model object
  # product - Product model object
  # photo - just photography read from some sorce
  def order_placed_email(user, product, photo)
    @user = user
    @product = product
    attachments.inline['product.jpg'] = photo

    mail to: @user.email,
         subject: "Вы только что заказали #{@product.name}"
  end
end
