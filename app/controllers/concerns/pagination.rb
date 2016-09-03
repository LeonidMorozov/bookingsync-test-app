module Pagination
  extend ActiveSupport::Concern

  def per_page
    if @per_page.nil?
      @per_page = params[:per_page].to_i if params[:per_page]
      @per_page ||= PAGINATION_PER_PAGE
    end
    @per_page
  end

  def page
    if @page.nil?
      @page = params[:page].to_i if params[:page]
      @page ||= 0
    end
    @page
  end

end
