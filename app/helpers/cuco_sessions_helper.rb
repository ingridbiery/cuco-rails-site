module CucoSessionsHelper
  # check if we have a valid google authorization
  def check_authorization?
    client = Google::APIClient.new(:application_name => "ib-calendar-test",
                                   :application_version => "1.0")
    client.authorization.access_token = current_user.token
    service = client.discovered_api('calendar', 'v3')
    result = client.execute(:api_method => service.settings.list,
                            :headers => {'Content-Type' => 'application/json'})

    # if there is an error, result.data["error"]["code"] will have the code
    # 401 is unauthorized
    # if there is no error, result.data["error"] will not exist
    return (result.data["error"] == nil or result.data["error"]["code"] != 401)
  end
end