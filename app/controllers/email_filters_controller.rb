# Class responsible for handling EmailConfigurationsController model controller.
class EmailFiltersController < ApplicationController
  unloadable

  before_filter :require_admin

  layout 'admin'

  def index
    @email_filters = EmailFilter.all.order(:position)
  end

  def show
  end

  def new
    @email_filter = EmailFilter.new
    @email_filter.email_filter_conditions.build
  end

  def edit
    @email_filter = EmailFilter.find(params[:id])

    if @email_filter.email_filter_conditions.count <= 0
      @email_filter.email_filter_conditions.build
    end
  end

  def create
    @email_filter = EmailFilter.new(params[:email_filter])
    @email_filter.position = EmailFilter.count

    if @email_filter.save
      redirect_to email_filters_url, notice: "Email filter creation is success!"
    else
      render action: 'new'
    end
  end

  def update
    @email_filter = EmailFilter.find(params[:id])

    if @email_filter.update_attributes(params[:email_filter])
      redirect_to email_filters_url, notice: "Successful update."
    else
      render action: 'edit'
    end
  end

  def destroy
    @email_filter = EmailFilter.find(params[:id])
    @email_filter.destroy
    redirect_to email_filters_url, notice: "Email filter deleted success!"
  end
end

