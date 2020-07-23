require 'jwt'

secret = "" # Found in Settings/Widget/Widget_security/Visitor_authentication
timestamp = Time.now.to_i

payload = {
  :name => "Authenticated User 2",
  :email => "test@example2.com",
  :iat => timestamp,
  :external_id => "test@example2.com"
}
token = JWT.encode payload, secret
puts token

IO.popen('pbcopy', 'w') { |f| f << token } # copy to pasteboard
