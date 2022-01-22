class HomesController < ApplicationController

  def top
  end

  def about
    if Rails.env.production?
      @random = Post.order("RAND()").limit(3)
    else
      @random = Post.order("RANDOM()").limit(3)
    end
  end

end
