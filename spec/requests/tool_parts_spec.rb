require 'spec_helper'

describe "ToolParts" do
  describe "GET /tool_parts" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get tool_parts_path
      response.status.should be(200)
    end
  end
end