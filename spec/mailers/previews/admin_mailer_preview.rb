# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/admin_mailer/order_placed_email
  def order_placed_email
    AdminMailer.order_placed_email
  end

  # Preview this email at http://localhost:3000/rails/mailers/admin_mailer/order_failed_email
  def order_failed_email
    AdminMailer.order_failed_email
  end

end
