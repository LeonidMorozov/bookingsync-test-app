module SearchParamsExamples
  shared_examples "positive int param examples" do
    it "valid value" do
      controller.params[param_name] = "5"
      expect(controller.send(:search_params)).to eql(param_name => 5)
    end
    it "non-int value" do
      controller.params[param_name] = "abc"
      expect(controller.send(:search_params)).to eql({})
    end
    it "value is negative" do
      controller.params[:param_name] = "-1"
      expect(controller.send(:search_params)).to eql({})
    end
    it "value is zero" do
      controller.params[:param_name] = "0"
      expect(controller.send(:search_params)).to eql({})
    end
    it "no value" do
      expect(controller.send(:search_params)).to eql({})
    end
  end

  shared_examples "non-blank string param examples" do
    it "valid value" do
      controller.params[param_name] = "abc"
      expect(controller.send(:search_params)).to eql(param_name => "abc")
    end
    it "empty string value" do
      controller.params[param_name] = ""
      expect(controller.send(:search_params)).to eql({})
    end
    it "no value" do
      expect(controller.send(:search_params)).to eql({})
    end
  end

  shared_examples "boolean param examples" do
    it "valid value" do
      controller.params[param_name] = true
      expect(controller.send(:search_params)).to eql(param_name => true)
    end
    it "valid string value" do
      controller.params[param_name] = "true"
      expect(controller.send(:search_params)).to eql(param_name => true)
    end
    it "invalid value" do
      controller.params[param_name] = "abc"
      expect(controller.send(:search_params)).to eql({})
    end
    it "no value" do
      expect(controller.send(:search_params)).to eql({})
    end
  end
end
