module CucoSessionsHelper
  # check if we have a valid google authorization. Do this by making a meaningless
  # request of google to see if it returns with an error.
  def check_authorization?
    client = Google::APIClient.new(:application_name => Workspace::GOOGLE_APPLICATION_NAME,
                                   :application_version => Workspace::GOOGLE_APPLICATION_VERSION)
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