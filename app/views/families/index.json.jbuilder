json.array!(@families) do |family|
  json.extract! family, :id, :family_name, :street_address, :city, :state, :zip
  json.url family_url(family, format: :json)
end
