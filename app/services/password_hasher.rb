class PasswordHasher < ApplicationService
  def initialize(password)
    @password = password
  end

  def call
    Digest::SHA256.hexdigest(@password)
  end
end
