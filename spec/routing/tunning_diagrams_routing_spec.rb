require "spec_helper"

describe TunningDiagramsController do
  describe "routing" do

    it "routes to #index" do
      get("/tunning_diagrams").should route_to("tunning_diagrams#index")
    end

    it "routes to #new" do
      get("/tunning_diagrams/new").should route_to("tunning_diagrams#new")
    end

    it "routes to #show" do
      get("/tunning_diagrams/1").should route_to("tunning_diagrams#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tunning_diagrams/1/edit").should route_to("tunning_diagrams#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tunning_diagrams").should route_to("tunning_diagrams#create")
    end

    it "routes to #update" do
      put("/tunning_diagrams/1").should route_to("tunning_diagrams#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tunning_diagrams/1").should route_to("tunning_diagrams#destroy", :id => "1")
    end

  end
end
