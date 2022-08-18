# frozen_string_literal: true

module Auth
  class JwtDecode
    def call(token:)
      JWT.decode(token, hmac_secret, true, { algorithm: hmac_algorithm }).first
    end

    private

    def hmac_secret
      ENV['HMAC_SECRET']
    end

    def hmac_algorithm
      ENV['HMAC_ALGORITHM']
    end
  end
end
