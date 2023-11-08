class ProductsController < ApplicationController
  def index
    @query = params[:query]
    @products = Product.all

    return if @query.blank?

    client = OpenSearch::Client.new(host: 'localhost:9200')

    # 形態素解析の結果
    @tokens = client.indices.analyze(
      index: Product::INDEX_NAME,
      body: {
        text: @query
      }
    )

    # 検索結果
    @response = client.search(
      index: Product::INDEX_NAME,
      body: {
        query: {
          function_score: {
            query: {
              multi_match: {
                query: @query,
                fields: %w[name category]
              }
            },
            field_value_factor: {
              field: 'average_rating',
              modifier: "log1p", # log(1+v)をもとにランク付け。さとふるのレビューは平均4.5・中央値4.8と高いので、大きな値に対してスコアの増加を抑えられるかなと
              factor: 1 # いったん適当に1にしておく
            }
          }
        }
      }
    )
    ids = @response['hits']['hits'].pluck('_id')
    @products = @products.where(id: ids)
  end
end
