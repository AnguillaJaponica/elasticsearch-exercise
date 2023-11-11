class SynonymsController < ApplicationController
  def index
    @synonyms = Synonym.all
  end
  
  def create
    synonym_params = params.require(:synonym).permit(:words)
    ApplicationRecord.transaction do
      Synonym.create!(synonym_params)
      # synonymを更新するためインデックスを再生成する
      Product.import
    end
    redirect_to synonyms_path
  end
  
  def destroy
    ApplicationRecord.transaction do
      Synonym.find(params[:id]).destroy!
      # synonymを更新するためインデックスを再生成する
      Product.import
    end
    redirect_to synonyms_path
  end
end
