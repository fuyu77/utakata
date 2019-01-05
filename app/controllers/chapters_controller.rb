# frozen_string_literal: true

class ChaptersController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy tanka]

  def new
    @chapter = current_user.chapters.build
  end

  def create
    @chapter = current_user.chapters.build(chapter_params)
    if @chapter.save
      redirect_to edit_chapter_path(@chapter.id), notice: '連作を作成しました'
    else
      redirect_back(fallback_location: root_path)
      flash[:alert] = @chapter.errors.full_messages
    end
  end

  def edit
    @chapter = Chapter.find(params[:id])
  end

  def update
    
  end

  def tanka
    @posts = current_user.posts.order('created_at DESC')
  end

  def posts
  end

  private

  def chapter_params
    params.require(:chapter).permit(:title, :description, :display_likes)
  end
end
