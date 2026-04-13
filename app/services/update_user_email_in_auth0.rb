class UpdateUserEmailInAuth0
  attr_reader :user

  def initialize(user:)
    @user = user
  end

  def call
    auth0_client.update_user(user.auth_id, email: user.email, verify_email: true, email_verified: false)
  end

  private

  def auth0_client
    @auth0_client ||= Auth0Api.new.client
  end
end
