# -*- coding: utf-8 -*-
class AnswersController < ApplicationController

  before_filter :authenticate_user!

  def create
    @file = UserFile.find(params[:answer][:file_id])
    if current_user == @file.owner
      @comment = @file.comments.find(params[:answer][:comment_id])
      @answer = @comment.answers.create(params[:answer].
                                        merge(:owner => current_user))
      if @answer.save
        flash[:notice] = "Resposta enviada com sucesso."
      else
        flash[:alert] = @answer.errors[0]
      end
    end

    redirect_to :back
  end

  def destroy
    @file = UserFile.find(params[:file_id])
    @answer = @file.comments.map(&:answers).flatten.find(params[:id]).first
    @answer.destroy unless current_user != @answer.owner
    flash[:notice] = "Resposta removida com sucesso."
  rescue
    flash[:alert] = "Não foi possível remover a resposta."
  ensure
    redirect_to :back
  end

end
