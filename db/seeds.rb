require 'csv'

csv_file_path = Rails.root.join('db', 'seeds', 'products.csv')

CSV.foreach(csv_file_path, headers: true, header_converters: :symbol) do |row|
  Product.create(
    name:           row[:name],
    link:           row[:link],
    average_rating: row[:star].to_f,  # star を average_rating にマップ
    price:          row[:price].to_i,
    category:       row[:category],
    created_at:     Time.now,  # created_at と updated_at を現在の時刻に設定
    updated_at:     Time.now
  )
end
