class SendEmailVerificationJob < ApplicationJob
  queue_as :default

  TEMPLATE_ID = '26164cdb-915b-4e13-97e9-d4a42367f068'.freeze

  def perform(new_email:, verification_url:)
    Notify.new.send_email(
      template_id: TEMPLATE_ID,
      email: new_email,
      vars: {
        verify_url: verification_url,
        new_email: new_email
      }
    )
  end
end
