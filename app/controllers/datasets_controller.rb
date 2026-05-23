class DatasetsController < ApplicationController
  def import 
    records = params.permit!.to_h["_json"]

    unless records.is_a? Array
      render json: {error: "Expected an array"}, status: :unprocessable_entity
      return
    end

    result = DatasetImporter.new(records).call
    render json: result, status: :ok
  end

  def index
    datasets = Dataset.search(params[:q])
    render json: datasets, status: :ok
  end
end