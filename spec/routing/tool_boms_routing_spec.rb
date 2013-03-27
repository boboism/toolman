require "spec_helper"

describe ToolBomsController do
  describe "routing" do

    it "routes to #index" do
      get("/tool_boms").should route_to("tool_boms#index")
    end

    it "routes to #new" do
      get("/tool_boms/new").should route_to("tool_boms#new")
    end

    it "routes to #show" do
      get("/tool_boms/1").should route_to("tool_boms#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tool_boms/1/edit").should route_to("tool_boms#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tool_boms").should route_to("tool_boms#create")
    end

    it "routes to #update" do
      put("/tool_boms/1").should route_to("tool_boms#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tool_boms/1").should route_to("tool_boms#destroy", :id => "1")
    end

  end
end
