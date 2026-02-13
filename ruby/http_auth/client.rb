require "net/http"
require "json"
require "uri"

login_uri = URI("http://localhost:9000/login")
req = Net::HTTP::Post.new(login_uri, "Content-Type" => "application/json")
req.body = { email: "kandy@kandy.com", password: "pass" }.to_json

res = Net::HTTP.start(login_uri.hostname, login_uri.port) { |http| http.request(req) }
unless res.is_a?(Net::HTTPSuccess)
  abort "Login failed: #{res.code} #{res.body}"
end

token = JSON.parse(res.body)["token"]
puts "Received token: #{token}"
puts "HTTP status: #{res.code}"

profile_uri = URI("http://localhost:9000/protected")
req2 = Net::HTTP::Get.new(profile_uri)
req2["Authorization"] = "Bearer #{token}"

res2 = Net::HTTP.start(profile_uri.hostname, profile_uri.port) { |http| http.request(req2) }
puts "HTTP status: #{res2.code}"
puts "Response body: #{res2.body}"
