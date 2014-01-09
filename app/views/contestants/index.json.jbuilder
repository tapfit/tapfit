json.array!(@contestants) do |contestant|
  json.extract! contestant, :email, :has_downloaded, :has_shared, :index, :show, :new
  json.url contestant_url(contestant, format: :json)
end