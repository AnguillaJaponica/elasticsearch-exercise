class ProductsController < ApplicationController
  def index
    @query = params[:query]
    @products = Product.all

    return if @query.blank?

    client = OpenSearch::Client.new(host: 'localhost:9200')
    @response = client.search(
      index: Product::INDEX_NAME,
      body: {
        query: {
          match: {
            name: @query
          }
        }
      }
    )
    ids = @response['hits']['hits'].pluck('_id')
    @products = @products.where(id: ids)
  end
end
