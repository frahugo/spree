require 'spec_helper'

module Spree
  describe Spree::ProductDuplicator do
    
    let(:product) { create(:product, properties: [create(:property, name: "MyProperty")])}
    let!(:duplicator) { Spree::ProductDuplicator.new(product)}
    
    let(:image) { File.open(File.expand_path('../../../fixtures/thinking-cat.jpg', __FILE__)) }
    let(:params) { {:viewable_id => product.master.id, :viewable_type => 'Spree::Variant', :attachment => image, :alt => "position 1", :position => 1} }

    before do
      Spree::Image.create(params)
    end

    it "will duplicate the product" do
      expect{duplicator.duplicate}.to change{Spree::Product.count}.by(1)
    end

    it "will duplicate the product images" do
      expect{duplicator.duplicate}.to change{Spree::Image.count}.by(1)
    end

    context "product attributes" do
      let!(:new_product) {duplicator.duplicate}
      
      it "will set an unique name" do
        expect(new_product.name).to eql "COPY OF #{product.name}"
      end

      it "will set a unique permalink" do
        expect(new_product.permalink).to include("copy-of-product-number")
      end

      it "will set an unique sku" do
        expect(new_product.sku).to eql "COPY OF ABC"
      end

      it "copied the properties" do
        expect(new_product.product_properties.count).to be 1
        expect(new_product.product_properties.first.property.name).to eql "MyProperty"
      end
    end

    context "with variants" do
      let!(:variant1) { create(:variant, product: product) }
      let!(:variant2) { create(:variant, product: product) }
      
      it  "will duplciate the variants" do
        # will change the count by 3, since there will be a master variant as well
        expect{duplicator.duplicate}.to change{Spree::Variant.count}.by(3)
      end
    end
  end
end
