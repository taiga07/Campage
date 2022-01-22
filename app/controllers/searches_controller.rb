class SearchesController < ApplicationController

  def search
    @model = params["model"]
    @content = params["content"]
    @records = search_for(@model, @content).page(params[:page]).per(8)
  end


  private
  def search_for(model, content)
    if model == 'user'
        User.where('name LIKE ?', '%'+content+'%')
    elsif model == 'post'
        Post.where('title LIKE ?', '%'+content+'%').or(Post.where('body LIKE ?', '%'+content+'%'))
    end
  end

end
