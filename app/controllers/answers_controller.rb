# -*- coding: utf-8 -*-
class AnswersController < ApplicationController

  def create
    @comment = Comment.find(params[:answer][:comment_id])
    if current_user == @comment.file.owner
      @answer = @comment.answers.create(params[:answer].merge(:owner => current_user))
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
