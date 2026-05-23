require "rails_helper"

RSpec.describe "Datasets", type: :request do
  describe "POST /datasets/import" do
    let(:valid_payload) do
      [
        { external_id: "dataset-1", title: "Climate Data", authors: ["John"], keywords: ["climate"] },
        { external_id: "dataset-2", title: "Ocean Data",   authors: ["Alice"], keywords: ["ocean"] }
      ]
    end

    it "imports valid records" do
      post "/datasets/import", params: valid_payload.to_json,
        headers: { "Content-Type" => "application/json" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq("imported" => 2, "failed" => 0, "duplicates" => 0)
    end

    it "detects duplicates within payload" do
      payload = [
        { external_id: "dataset-1", title: "Climate Data", keywords: [], authors: [] },
        { external_id: "dataset-2", title: "Climate Data", keywords: [], authors: [] }
      ]

      post "/datasets/import", params: payload.to_json,
        headers: { "Content-Type" => "application/json" }

      expect(JSON.parse(response.body)).to eq("imported" => 1, "failed" => 0, "duplicates" => 1)
    end

    it "detects duplicates against existing records" do
      create(:dataset, external_id: "dataset-1", title: "Climate Data")

      post "/datasets/import", params: valid_payload.to_json,
        headers: { "Content-Type" => "application/json" }

      expect(JSON.parse(response.body)).to eq("imported" => 1, "failed" => 0, "duplicates" => 1)
    end

    it "rejects invalid records" do
      payload = [{ external_id: nil, title: "", authors: [], keywords: [] }]

      post "/datasets/import", params: payload.to_json,
        headers: { "Content-Type" => "application/json" }

      expect(JSON.parse(response.body)).to eq("imported" => 0, "failed" => 1, "duplicates" => 0)
    end

    it "handles keywords as string" do
      payload = [{ external_id: "dataset-1", title: "Climate Data", authors: [], keywords: "climate" }]

      post "/datasets/import", params: payload.to_json,
        headers: { "Content-Type" => "application/json" }

      expect(JSON.parse(response.body)["imported"]).to eq(1)
    end
  end

  describe "GET /datasets" do
    before do
      create(:dataset, external_id: "dataset-1", title: "Climate Change", keywords: ["climate"])
      create(:dataset, external_id: "dataset-2", title: "Nature Data", keywords: ["forest"])
    end

    it "returns matching results" do
      get "/datasets?q=climate"
      results = JSON.parse(response.body)
      expect(results.length).to eq(1)
      expect(results.first["title"]).to eq("Climate Change")
    end
  end
end
