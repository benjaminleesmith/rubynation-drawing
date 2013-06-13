class EntriesController < ApplicationController
  def create
    entry = Entry.new(params[:entry])
    if entry.save
       render json: {
           message: "You have a #{Entry.chance_to_win} chance to win an iPod Nan"
       }
    else
       if entry.errors[:email] == ["can't be blank"]
         render status: 422, json: {
             message: "Must provide email to enter!"
         }
       elsif entry.errors[:email] == ["has already been taken"]
         render status: 422, json: {
             message: "Only one entry allowed per email!"
         }
       else
         render status: 418, json: {
             message: "Ack! Something went wrong! Tell @benjamin_smith that something went wrong!"
         }
       end
    end
  end
end