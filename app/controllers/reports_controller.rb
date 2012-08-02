class ReportsController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!

  layout 'user_panel'

  def show
    start_date = params[:start_date].blank? ? 30.days.ago.to_date : Date.strptime(params[:start_date], "%d/%m/%Y")
    @start_date = [start_date, current_user.created_at.to_date].max
    @end_date  = [start_date, params[:end_date].blank? ? Date.today : Date.strptime(params[:end_date], "%d/%m/%Y")].max
    @statistics = current_user.daily_statistics.where(:date.in => (@start_date..@end_date).to_a)

    respond_with(@statistics)
  end
end
