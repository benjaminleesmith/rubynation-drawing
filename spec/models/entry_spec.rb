require 'spec_helper'

describe Entry do
  describe "validations" do
    it "can be valid" do
      entry = Entry.create!({email: "foo@example.com"})

      entry.valid?.should == true
      entry.persisted?.should == true
      entry.email.should == "foo@example.com"
    end

    it "validates presence of email" do
      entry = Entry.create({email: ""})

      entry.valid?.should == false
      entry.persisted?.should == false

      entry.errors[:email].should == ["can't be blank"]
    end

    it "validates uniqueness of email" do
      Entry.create!({email: "foo@example.com"})

      entry = Entry.create({email: "foo@example.com"})
      entry.valid?.should == false
      entry.persisted?.should == false

      entry.errors[:email].should == ["has already been taken"]
    end
  end

  describe ".chance_to_win" do
    it "handles less entries than winners" do
      Entry.stub(:WINNERS).and_return(10)

      Entry.chance_to_win.should == "100%"

      Entry.create!({email: "foo@example.com"})

      Entry.chance_to_win.should == "100%"
    end

    it "handles when everyone can't be a winner" do
      Entry::WINNERS = 1

      Entry.create!({email: "foo@example.com"})
      Entry.create!({email: "bar@example.com"})

      Entry.chance_to_win.should == "50%"
    end
  end
end
