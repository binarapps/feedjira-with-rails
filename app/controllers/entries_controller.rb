class EntriesController < ApplicationController

  def index
    @entries = Entry.all.order(published: :desc)
  end

  def show
    @entry = Entry.find(params[:id])
  end

  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy
    redirect_to entries_path
  end
end
