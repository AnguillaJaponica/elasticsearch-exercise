class Product < ApplicationRecord
  INDEX_NAME = 'products'

  def self.import
    client = OpenSearch::Client.new(host: 'localhost:9200')

    client.indices.delete(index: INDEX_NAME) rescue nil
    client.indices.create(index: INDEX_NAME)

    self.find_each do |product|
      client.index(
        index: INDEX_NAME,
        id: product.id,
        body: {
          name: product.name,
          category: product.category,
          average_rating: product.average_rating,
          price: product.price,
        },
      )
    end
  end
end
