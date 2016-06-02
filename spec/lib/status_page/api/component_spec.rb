require 'spec_helper'
require 'status_page'

describe StatusPage::API::Component do

  describe "instance methods" do
    let(:id){ "abcd" }
    let(:page_id){ "wxyz" }
    let(:component){ described_class.new id, page_id }

    describe "id" do
      subject { component.id }
      it { is_expected.to eq id }
    end

    describe "page_id" do
      subject { component.page_id }
      it { is_expected.to eq page_id }
    end

    describe "get" do
      subject { component.get }

      context "with successful get" do
        let(:result_attributes) do
          {
            "status"=>"operational",
            "name"=>"Example site",
            "created_at"=>"2015-07-14T19:41:51.042Z",
            "updated_at"=>"2016-05-26T21:32:09.450Z",
            "position"=>1,
            "description"=>"Hello",
            "id"=>"abcd",
            "page_id"=>"wxyz",
            "group_id"=>"nqrw"
          }
        end
        before { allow(component).to receive(:get_resource).and_return result_attributes }

        it { is_expected.to eq result_attributes }

        context "after load" do
          before { subject }
          it "should assign id" do
            expect(component.id).to eq "abcd"
          end
          it "should assign page_id" do
            expect(component.page_id).to eq "wxyz"
          end
          it "should assign status" do
            expect(component.status).to eq "operational"
          end
          it "should assign name" do
            expect(component.name).to eq "Example site"
          end
          it "should assign created_at" do
            expect(component.created_at).to eq "2015-07-14T19:41:51.042Z"
          end
          it "should assign updated_at" do
            expect(component.updated_at).to eq "2016-05-26T21:32:09.450Z"
          end
          it "should assign position" do
            expect(component.position).to eq 1
          end
          it "should assign description" do
            expect(component.description).to eq "Hello"
          end
          it "should assign group_id" do
            expect(component.group_id).to eq "nqrw"
          end
        end
      end

      context "with unsuccessful get" do
        before { allow(component).to receive(:get_resource).and_raise RuntimeError, "some error" }

        it "should raise that error" do
          expect{ subject }.to raise_error RuntimeError, "some error"
        end
      end
    end

    describe "save" do
      subject { component.save }
      let(:result_attributes) do
        {
          "status"=>"major_outage",
          "name"=>"Example site",
          "created_at"=>"2015-07-14T19:41:51.042Z",
          "updated_at"=>"2016-05-26T21:32:09.450Z",
          "position"=>4,
          "description"=>"Hello",
          "id"=>"abcd",
          "page_id"=>"wxyz",
          "group_id"=>"nqrw"
        }
      end
      before { allow(component).to receive(:patch_resource).and_return result_attributes }

      context "with attributes assigned" do
        let(:attributes) do
          {
            "status"=>"major_outage",
            "name"=>"Example site",
            "created_at"=>"2015-07-14T19:41:51.042Z",
            "updated_at"=>"2016-05-26T21:32:09.450Z",
            "position"=>1,
            "description"=>"Hello",
            "id"=>"abcd",
            "page_id"=>"wxyz",
            "group_id"=>"nqrw"
          }
        end
        before { component.send(:assign_attributes, attributes) }

        context "with successful response" do
          it { is_expected.to eq result_attributes }

          it "should call patch_resource with correct hash" do
            expect(component).to receive(:patch_resource).with({component: {status: "major_outage", description: "Hello", name: "Example site"}})
            subject
          end

          it "should assign any changed attributes" do
            subject
            expect(component.position).to eq 4
          end
        end

        context "with unsuccessful response" do
          before { allow(component).to receive(:patch_resource).and_raise RuntimeError, "some error" }

          it "should raise that error" do
            expect{ subject }.to raise_error RuntimeError, "some error"
          end
        end
      end

      context "with attributes unassigned" do
        it "should not call patch_resource" do
          expect(component).to_not receive(:patch_resource)
          subject
        end
      end
    end

    describe "failing?" do
      subject { component.failing? }
      context "when status operational" do
        before { component.status = "operational" }
        it { is_expected.to be_falsy }
      end
      context "when status not operational" do
        before { component.status = "major_outage" }
        it { is_expected.to be_truthy }
      end
    end

    describe "status=" do
      subject { component.status = status_type }
      let(:status_type){ "major_outage" }

      it "should assign status" do
        subject
        expect(component.status).to eq status_type
      end

      context "with invalid status" do
        let(:status_type){ "xyz" }
        it "should raise error" do
          expect{ subject }.to raise_error "Status 'xyz' not recognized. Valid statuses: [\"operational\", \"degraded_performance\", \"partial_outage\", \"major_outage\"]"
        end
      end
    end

    describe "resource_path" do
      subject { component.resource_path }
      it { is_expected.to eq "pages/#{page_id}/components/#{id}.json" }
    end

    describe "assign_attributes" do
      subject { component.assign_attributes attributes }

      context "given valid attributes with string keys" do
        let(:attributes) do
          {
            "status"=>"operational",
            "name"=>"Example site",
            "created_at"=>"2015-07-14T19:41:51.042Z",
            "updated_at"=>"2016-05-26T21:32:09.450Z",
            "position"=>1,
            "description"=>"Hello",
            "id"=>"abcd",
            "page_id"=>"wxyz",
            "group_id"=>"nqrw"
          }
        end

        it { is_expected.to eq attributes }

        context "after call" do
          before { subject }
          it "should assign id" do
            expect(component.id).to eq "abcd"
          end
          it "should assign page_id" do
            expect(component.page_id).to eq "wxyz"
          end
          it "should assign status" do
            expect(component.status).to eq "operational"
          end
          it "should assign name" do
            expect(component.name).to eq "Example site"
          end
          it "should assign created_at" do
            expect(component.created_at).to eq "2015-07-14T19:41:51.042Z"
          end
          it "should assign updated_at" do
            expect(component.updated_at).to eq "2016-05-26T21:32:09.450Z"
          end
          it "should assign position" do
            expect(component.position).to eq 1
          end
          it "should assign description" do
            expect(component.description).to eq "Hello"
          end
          it "should assign group_id" do
            expect(component.group_id).to eq "nqrw"
          end
        end
      end

      context "given valid attributes with symbol keys" do
        let(:attributes) do
          {
            status: "operational",
            name: "Example site",
            created_at: "2015-07-14T19:41:51.042Z",
            updated_at: "2016-05-26T21:32:09.450Z",
            position: 1,
            description: "Hello",
            id: "abcd",
            page_id: "wxyz",
            group_id: "nqrw"
          }
        end

        it { is_expected.to eq attributes }

        context "after call" do
          before { subject }
          it "should assign id" do
            expect(component.id).to eq "abcd"
          end
          it "should assign page_id" do
            expect(component.page_id).to eq "wxyz"
          end
          it "should assign status" do
            expect(component.status).to eq "operational"
          end
          it "should assign name" do
            expect(component.name).to eq "Example site"
          end
          it "should assign created_at" do
            expect(component.created_at).to eq "2015-07-14T19:41:51.042Z"
          end
          it "should assign updated_at" do
            expect(component.updated_at).to eq "2016-05-26T21:32:09.450Z"
          end
          it "should assign position" do
            expect(component.position).to eq 1
          end
          it "should assign description" do
            expect(component.description).to eq "Hello"
          end
          it "should assign group_id" do
            expect(component.group_id).to eq "nqrw"
          end
        end
      end

      context "given empty hash" do
        let(:attributes){ {} }

        it { is_expected.to eq attributes }
      end
    end
  end
end
