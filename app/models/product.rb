class Product < ApplicationRecord
  INDEX_NAME = 'products'

  def self.import
    client = OpenSearch::Client.new(host: 'localhost:9200')

    client.indices.delete(index: INDEX_NAME) rescue nil
    client.indices.create(index: INDEX_NAME, body: {
      settings: {
        analysis: {
          analyzer: {
            default: { # 別名で追加することもできるが、マッピングの設定が面倒なので default を上書きする
              type: "custom",
              tokenizer: "kuromoji_tokenizer",
              filter: [
                "kuromoji_readingform", # 漢字に読み仮名を付与
                "custom_synonym_filter",
              ],
            }
          },
          filter: {
            custom_synonym_filter: {
              type: "synonym",
              synonyms: [] # TOOD: 類義語を設定できるようにする
            }
          }
        }
      },
    })

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
