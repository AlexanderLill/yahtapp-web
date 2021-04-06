json.data do
  json.(user, :id, :email, :username, :role)
  unless @current_token.nil?
    json.token @current_token
  end
end
