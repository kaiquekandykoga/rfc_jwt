require "jwt"

# The ruby-jwt gem provides JWT.encode(payload, key, algorithm, header_fields)
# JOSE Header
# - algorithm: the signing algorithm used (e.g., HS256, RS256)
# - header_fields: additional header fields (e.g., "typ": "JWT")
# JWT Claims
# - payload: the data and JWT Claims like "sub", "name", "iat", etc.
# Signature / Authentication Tag
# - key: the secret key used to sign the JWT
# - algorithm: the signing algorithm used (e.g., HS256, RS256)

module RFC
  module Samples
    def self.encode_jwt(payload, key, alg, header_fields = {})
      token = JWT.encode(payload, key, alg, header_fields)
      token
    end

    def self.decode_jwt(payload, key, alg)
      decoded_token = JWT.decode(payload, key, true, { algorithm: alg })
      decoded_token
    end
  end
end

puts "→ Unsecured JWT"
puts "JOSE Header without specifing an algorithm (alg: none)"
token = RFC::Samples.encode_jwt({ data: "test" }, nil, "none")
puts "Encoded JWT: #{token}" # eyJhbGciOiJub25lIn0.eyJkYXRhIjoidGVzdCJ9.
decoded_token = RFC::Samples.decode_jwt(token, nil, "none")
puts "Decoded JWT: #{decoded_token}" # [{"data"=>"test"}, {"alg"=>"none"}]
