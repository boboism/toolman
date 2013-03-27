require "spec_helper"

describe ToolPartsController do
  describe "routing" do

    it "routes to #index" do
      get("/tool_parts").should route_to("tool_parts#index")
    end

    it "routes to #new" do
      get("/tool_parts/new").should route_to("tool_parts#new")
    end

    it "routes to #show" do
      get("/tool_parts/1").should route_to("tool_parts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tool_parts/1/edit").should route_to("tool_parts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tool_parts").should route_to("tool_parts#create")
    end

    it "routes to #update" do
      put("/tool_parts/1").should route_to("tool_parts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tool_parts/1").should route_to("tool_parts#destroy", :id => "1")
    end

  end
end
