require "roda"
require "json"
require "jwt"
require "bcrypt"
require "time"

class Server < Roda
  USERS = {
    "kandy@kandy.com" => {
      password_hash: BCrypt::Password.create("pass"),
      id: 0
    }
  }

  JWT_SECRET = "JWT_SECRET"
  ALGORITHM = "HS256"
  ACCESS_EXP = 16 # seconds

  route do |r|
    # Generate token
    # params should be JSON with "email" and "password"
    r.post "login" do
      body = r.body.read
      begin
        params = JSON.parse(body)
      rescue JSON::ParserError
        response.status = 400
        next { error: "Invalid JSON" }.to_json
      end

      user = USERS[params["email"]]
      if user && BCrypt::Password.new(user[:password_hash]) == params["password"]
        payload = { user_id: user[:id], exp: (Time.now.to_i + ACCESS_EXP) }
        token = JWT.encode(payload, JWT_SECRET, ALGORITHM)
        response.status = 201
        { token: token, exp: Time.at(payload[:exp]).utc.iso8601 }.to_json
      else
        response.status = 401
        { error: "Invalid credentials" }.to_json
      end
    end

    # Protected route
    # params should include Authorization: Bearer <token>
    r.get "protected" do
      auth = request.env["HTTP_AUTHORIZATION"]
      unless auth
        response.status = 401
        next { error: "Missing Authorization header" }.to_json
      end

      scheme, token = auth.split(" ", 2)
      unless scheme == "Bearer" && token
        response.status = 401
        next { error: "Malformed Authorization header" }.to_json
      end

      begin
        decoded, = JWT.decode(token, JWT_SECRET, true, algorithm: ALGORITHM)
        user_id = decoded["user_id"]
        { id: user_id, message: "This is a protected resource" }.to_json
      rescue JWT::ExpiredSignature
        response.status = 401
        { error: "Token expired" }.to_json
      rescue JWT::DecodeError
        response.status = 401
        { error: "Invalid token" }.to_json
      end
    end

    r.root do
      {
        message: "Roda JWT demo. POST /login then GET /protected with Authorization: Bearer <token>"
      }.to_json
    end
  end
end
