class ClientMailer < ApplicationMailer
  default from: 'no-reply@caterpillar-erp.com' # Cambia esto por tu correo real en el futuro

  def welcome_email(user, raw_password)
    @user = user
    @raw_password = raw_password
    @client = user.roleable # El modelo Client

    mail(
      to: @user.email,
      subject: '¡Bienvenido a nuestro Portal de Clientes! - Tus accesos'
    )
  end
end
