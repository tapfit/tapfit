json.array!(@contests) do |contest|
  json.extract! contest, :name, :url, :body, :start_date, :end_date, :is_live
  json.url contest_url(contest, format: :json)
end