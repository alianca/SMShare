class FaqController < ApplicationController

  before_filter :set_active

  def set_active
    @active_header_tab = :about
    @active_footer = :faq
  end

  def downloading
    @active_tab = :downloading;
  end

  def uploading
    @active_tab = :uploading;
  end

  def finances
    @active_tab = :finances;
  end

  def general
    @active_tab = :general;
  end

  def panel
    @active_tab = :panel;
  end

end
