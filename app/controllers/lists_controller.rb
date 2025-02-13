class ListsController < ApplicationController
  def create
    List.create(list_params[:list])
  end

  private

    def lists_params
      params.expect(list: [ :name ])
    end

    def book
      @book ||= Book.find(params[:book_id])
    end
end
