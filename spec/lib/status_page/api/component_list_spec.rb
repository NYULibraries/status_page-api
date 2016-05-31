require 'spec_helper'
require 'status_page'

describe StatusPage::API::ComponentList do
  let(:page_id){ "zzzz" }
  let(:component_list){ described_class.new page_id }

  describe "get" do
    subject { component_list.get }
    # stub out request
    let(:array_response) do
      [
        {"status"=>"operational", "name"=>"Library.nyu.edu", "id"=>"abcd", "page_id"=>"zzzz"},
        {"status"=>"operational", "name"=>"E-Shelf", "id"=>"1234", "page_id"=>"zzzz"},
        {"status"=>"operational", "name"=>"Login", "id"=>"wxyz", "page_id"=>"zzzz"},
      ]
    end
    let(:component_class){ StatusPage::API::Component }
    let(:component1){ double component_class, assign_attributes: true }
    let(:component2){ double component_class, assign_attributes: true }
    let(:component3){ double component_class, assign_attributes: true }
    before do
      allow(component_list).to receive(:get_resource).and_return array_response
      allow(component_class).to receive(:new).and_return component1, component2, component3
    end

    it { is_expected.to be_a Array }
    it { is_expected.to match_array [component1, component2, component3] }

    it "should initialize each instance correctly" do
      expect(component_class).to receive(:new).with("abcd", "zzzz").once
      expect(component_class).to receive(:new).with("1234", "zzzz").once
      expect(component_class).to receive(:new).with("wxyz", "zzzz").once
      subject
    end

    it "should call assign_attributes on each instance" do
      expect(component1).to receive(:assign_attributes).with(array_response[0])
      expect(component2).to receive(:assign_attributes).with(array_response[1])
      expect(component3).to receive(:assign_attributes).with(array_response[2])
      subject
    end

    it "should persist array to instance" do
      subject
      expect(component_list).to match_array [component1, component2, component3]
    end
  end

  describe "resource_path" do
    subject { component_list.resource_path }
    it { is_expected.to eq "pages/#{page_id}/components.json" }
  end
end
