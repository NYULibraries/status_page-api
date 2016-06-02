require 'spec_helper'
require 'status_page'

describe StatusPage::API::Base do
  let(:base){ described_class.new }

  describe "execute" do
    context "with STATUS_PAGE_API_KEY" do
      # stub out api key env variable
      let(:status_page_api_key){ "XXXX" }
      around do |example|
        with_modified_env STATUS_PAGE_API_KEY: status_page_api_key do
          example.run
        end
      end

      context "given successful response" do
        # stub out request/response
        let(:response){ {"name"=>"apple", "id"=>"xyz"} }
        let(:json_response){ response.to_json }
        let(:url_result){ "https://api.statuspage.io/v1/sample/path.json" }
        before do
          allow(RestClient::Request).to receive(:execute).and_return json_response
        end

        it "should call execute with URL generated from path" do
          expect(RestClient::Request).to receive(:execute).with(hash_including(url: url_result))
          base.execute "sample/path.json", method: :get
        end

        it "should call execute with method specified" do
          expect(RestClient::Request).to receive(:execute).with(hash_including(method: :patch))
          base.execute "sample/path.json", method: :patch
        end

        it "should call execute with headers" do
          expect(RestClient::Request).to receive(:execute).with(hash_including(headers: {"Authorization" => "OAuth #{status_page_api_key}", "Content-Type" => "application/json"}))
          base.execute "sample/path.json", method: :get
        end

        it "should raise error if no method specified" do
          expect{ base.execute "sample/path.json" }.to raise_error ArgumentError
        end

        it "should call execute with any additional options specified" do
          expect(RestClient::Request).to receive(:execute).with(hash_including(option: :value, arr: [1,2]))
          base.execute "sample/path.json", method: :patch, option: :value, arr: [1,2]
        end

        it "should return parsed json" do
          expect(JSON).to receive(:parse).with(json_response).and_call_original
          expect(base.execute("sample/path.json", method: :patch)).to eq response
        end
      end

      context "given 422 response" do
        # stub out request/response
        let(:error){ RestClient::UnprocessableEntity.new }
        let(:json_response){ {"error" => ["Something went wrong"]}.to_json }
        before do
          allow(RestClient::Request).to receive(:execute).and_raise error
          allow(error).to receive(:response).and_return json_response
        end

        it "should raise validation error parsed from response" do
          expect{ base.execute "sample/path.json", method: :patch }.to raise_error "Something went wrong"
        end
      end

      context "given other error response" do
        # stub out request/response
        let(:error){ RestClient::ResourceNotFound.new }
        before do
          allow(RestClient::Request).to receive(:execute).and_raise error
        end

        it "should raise the error" do
          expect{ base.execute "sample/path.json", method: :patch }.to raise_error error
        end
      end
    end

    context "without STATUS_PAGE_API_KEY" do
      # stub out api key env variable
      around do |example|
        with_modified_env STATUS_PAGE_API_KEY: nil do
          example.run
        end
      end

      it "should raise an error without calling api" do
        expect(RestClient::Request).to_not receive(:execute)
        expect{ base.execute "sample/path.json", method: :get }.to raise_error "Must specify STATUS_PAGE_API_KEY to use StatusPage"
      end
    end

  end

  describe "get_resource" do
    subject { base.get_resource }
    let(:result){ {a: :b} }
    before { allow(base).to receive(:execute).and_return result }

    context "with resource_path defined" do
      let(:path){ "/some/path.json" }
      before do
        base.define_singleton_method(:resource_path){ "/some/path.json" }
      end

      it { is_expected.to eq result }

      it "should call execute with correct parameters" do
        expect(base).to receive(:execute).with(path, method: :get)
        subject
      end
    end

    context "without resource_path defined" do
      it "should raise error" do
        expect{ subject }.to raise_error("Must define resource_path in your subclass")
      end
    end
  end

  describe "patch_resource" do
    subject { base.patch_resource payload }
    let(:payload){ {some: :thing} }
    let(:result){ {a: :b} }
    before { allow(base).to receive(:execute).and_return result }

    context "with resource_path defined" do
      let(:path){ "/some/path.json" }
      before do
        base.define_singleton_method(:resource_path){ "/some/path.json" }
      end

      context "with hash payload" do
        it { is_expected.to eq result }

        it "should call execute with path and method" do
          expect(base).to receive(:execute).with(path, hash_including(method: :patch))
          subject
        end

        it "should call execute with payload as json" do
          expect(base).to receive(:execute).with(path, hash_including(payload: payload.to_json))
          subject
        end
      end

      context "with string payload" do
        let(:payload){ "abcd" }

        it { is_expected.to eq result }

        it "should call execute with path and method" do
          expect(base).to receive(:execute).with(path, hash_including(method: :patch))
          subject
        end

        it "should call execute with payload as json" do
          expect(base).to receive(:execute).with(path, hash_including(payload: payload.to_json))
          subject
        end
      end

      context "with nil payload" do
        let(:payload){ nil }

        it { is_expected.to eq result }

        it "should call execute with path and method" do
          expect(base).to receive(:execute).with(path, hash_including(method: :patch))
          subject
        end

        it "should call execute with json null payload" do
          expect(base).to receive(:execute).with(path, hash_including(payload: payload.to_json))
          subject
        end
      end
    end

    context "without resource_path defined" do
      it "should raise error" do
        expect{ subject }.to raise_error("Must define resource_path in your subclass")
      end
    end
  end


end
