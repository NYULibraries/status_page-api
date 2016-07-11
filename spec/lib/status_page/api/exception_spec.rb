require 'spec_helper'
require 'status_page'

describe StatusPage::API::Exception do
  let(:exception){ described_class.new rest_client_error }

  describe "message" do
    subject{ exception.message }

    before do
      allow(exception).to receive(:response).and_return response
    end

    context "given response known to RestClient (422)" do
      let(:rest_client_error){ RestClient::UnprocessableEntity.new }
      let(:response){ "Something went wrong" }

      it { is_expected.to eq "Unprocessable Entity (Something went wrong)" }
    end

    context "given response unknown to RestClient (420)" do
      let(:rest_client_error){ RestClient::RequestFailed.new }
      let(:response){ "Slow your roll" }
      let(:http_code){ 420 }
      before do
        allow(rest_client_error).to receive(:http_code).and_return http_code
      end

      it { is_expected.to eq "HTTP status code 420 (Slow your roll)" }
    end

    context "given empty error response" do
      let(:rest_client_error){ RestClient::ResourceNotFound.new }
      let(:response){ "NO RESPONSE" }

      it { is_expected.to eq "Resource Not Found (NO RESPONSE)" }
    end
  end

  describe "response" do
    subject{ exception.response }

    context "given response known to RestClient (422)" do
      let(:rest_client_error){ RestClient::UnprocessableEntity.new }
      let(:json_response){ {"error" => ["Something went wrong"]}.to_json }
      before do
        allow(rest_client_error).to receive(:response).and_return json_response
      end

      it { is_expected.to eq "Something went wrong" }
    end

    context "given response unknown to RestClient (420)" do
      let(:rest_client_error){ RestClient::RequestFailed.new }
      let(:json_response){ {"error" => "Slow your roll"}.to_json }
      before do
        allow(rest_client_error).to receive(:response).and_return json_response
      end

      it { is_expected.to eq "Slow your roll" }
    end

    context "given empty error response" do
      let(:rest_client_error){ RestClient::ResourceNotFound.new }

      it { is_expected.to eq "NO RESPONSE" }
    end
  end
end
