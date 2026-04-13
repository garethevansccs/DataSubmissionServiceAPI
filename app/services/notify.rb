require 'notifications/client'

class Notify
  def initialize
    @client = Notifications::Client.new('rmi_api_notify_api_key-5b735cba-25af-44ca-9494-849b2745365f-e3c04538-df80-4fd1-be19-659b1445e235')
  end

  def send_email(template_id:, email:, vars: {})
    @client.send_email(
      email_address: email,
      template_id: template_id,
      personalisation: vars
    )
  rescue Notifications::Client::RequestError => e
    Rails.logger.error "GOV.UK Notify Error: #{e.message}"
    false
  end
end
