json.data do
  json.(user, :id, :email, :username, :role, :reflection_on, :reflection_at)
  unless @current_token.nil?
    json.token @current_token
  end
end
