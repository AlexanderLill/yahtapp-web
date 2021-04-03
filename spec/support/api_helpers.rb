module ApiHelpers

  def json
    JSON.parse(response.body)
  end

  def login_with_api(user, version = :v1)
    post "/api/#{version}/auth", params: {
      user: {
        login: user.email,
        password: user.password
      }
    }
  end

end
