class Product < ApplicationRecord
  INDEX_NAME = 'products'

  def self.import
    client = OpenSearch::Client.new(host: 'localhost:9200')

    client.indices.delete(index: INDEX_NAME) rescue nil
    client.indices.create(index: INDEX_NAME)

    self.find_in_batches do |products|
      actions = products.map do |product|
        {
          index: {
            _index: INDEX_NAME,
            _id: product.id,
            data: {
              name: product.name,
              category: product.category,
              average_rating: product.average_rating,
              price: product.price,
            }
          }
        }
      end
      client.bulk(body: actions)
    end
  end
end
