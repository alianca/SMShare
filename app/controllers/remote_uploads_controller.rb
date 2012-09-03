# -*- coding: utf-8 -*-
class RemoteUploadsController < ApplicationController
  layout 'user_panel'

  def new
    @file = UserFile.new
  end
end
