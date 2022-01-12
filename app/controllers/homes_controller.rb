class HomesController < ApplicationController

  def top
  end

  def about
    @random = Post.order("RANDOM()").limit(3)
  end

end
