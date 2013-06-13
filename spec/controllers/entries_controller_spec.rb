require "spec_helper"

describe EntriesController do
  describe "POST #create" do
    it "creates an entry" do
           expect {
             post :create, entry: {email: "foo@example.com"}
           }.to change{Entry.count}.from(0).to(1)

           Entry.last.email.should == "foo@example.com"
         end

         context "success" do
           it "returns 200 with chances to win" do
             Entry::WINNERS = 1
             Entry.create!({email: "bar@example.com"})

             post :create, entry: {email: "foo@example.com"}

             JSON.parse(response.body).should == {
                 "message" => "You have a 50% chance to win an iPod Nano!"
             }
             response.status.should == 200
           end
         end

         context "failure" do
           it "returns 422 with duplicate email error" do
             Entry.create!({email: "foo@example.com"})

             expect {
               post :create, entry: {email: "foo@example.com"}
             }.to_not change {Entry.count}

             JSON.parse(response.body).should == {
                 "message" => "Only one entry allowed per email!"
             }
             response.status.should == 422
           end

           it "returns 422 with blank email error" do
             expect {
               post :create, entry: {email: ""}
             }.to_not change {Entry.count}

             JSON.parse(response.body).should == {
                 "message" => "Must provide email to enter!"
             }
             response.status.should == 422
           end

           it "catch all error handling" do
             Entry.any_instance.should_receive(:save).and_return false

             post :create, entry: {email: "asdf@example.com"}

             JSON.parse(response.body).should == {
                 "message" => "Ack! Something went wrong! Tell @benjamin_smith that something went wrong!"
             }
             response.status.should == 418
           end
         end
  end
end