
class OpensearchController < ApplicationController 
  def index
    client = OpenSearch::Client.new(host: 'localhost:9200')

    @health = client.ping
    @indices = client.cat.indices(format: 'json') rescue nil
  end
end
