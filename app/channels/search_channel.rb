class SearchChannel < ApplicationCable::Channel
  def subscribed
    stream_from "SearchChannel"
  end

  def unsubscribed
    Rails.logger "Disconnected from channel..."
  end
end
