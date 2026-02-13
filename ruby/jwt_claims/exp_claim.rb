require "jwt"

# Test the "exp" (Expiration Time) claim of 4 seconds from now
# The JWT is able to decode successfully until the "exp" claim is reached

exp = Time.now.to_i + 4 # 4 seconds from now
payload = { data: "test", exp: exp }
token = JWT.encode(payload, nil, "none")
puts "Encoded JWT with exp claim: #{token}"

begin
  8.times do |i|
    sleep(1)
    decoded_token = JWT.decode(token, nil, true, { algorithm: "none" })
    puts "Decoded JWT with exp claim: #{decoded_token}"
  end
rescue JWT::ExpiredSignature
  puts "JWT has expired"
end
