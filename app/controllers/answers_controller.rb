# -*- coding: utf-8 -*-
class AnswersController < ApplicationController

  before_filter :authenticate_user!

  def create
    @file = File.find(params[:file_id])
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
    @answer = Answer.find(params[:id])
    @answer.destroy unless current_user != @answer.owner

    redirect_to :back
  end

end
