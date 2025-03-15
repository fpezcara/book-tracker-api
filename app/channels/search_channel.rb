class SearchChannel < ApplicationCable::Channel
  def subscribed
    query = params[:query].to_s
    search_by = params[:search_by].to_s
    # channel_name = "search_#{query}_#{search_by}".parameterize

    # puts "Channel name in seach_channel: ", channel_name

    stream_from "SearchChannel"
  end

  def unsubscribed
    Rails.logger "Disconnected from channel..."
    # Cleanup code if needed when the user unsubscribes
  end
end
