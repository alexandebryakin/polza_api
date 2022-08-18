# frozen_string_literal: true

module Auth
  class JwtEncode
    def call(data:)
      payload = { data:, exp: expires_at.to_i }

      JWT.encode(payload, hmac_secret, hmac_algorithm)
    end

    private

    def expires_at
      Time.current + 4.hours
    end

    def hmac_secret
      ENV['HMAC_SECRET']
    end

    def hmac_algorithm
      ENV['HMAC_ALGORITHM']
    end
  end
end
