class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(permit_post)
    if @post.save
      flash[:success] = "Success!"
      redirect_to post_path(@post)
    else
      flash[:error] = @post.errors.full_messages
      redirect_to new_post_path
    end
  end

  def edit
    @post = Post.find(params[:id])
    unless @post.user == current_user
      flash[:error] = "Solo el dueño puede editar este post"
      redirect_to posts_path
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.user != current_user
      flash[:error] = "Solo el dueño puede editar este post"
      redirect_to posts_path
    elsif @post.update(permit_post)
      flash[:success] = "Post actualizado"
      redirect_to post_path(@post)
    else
      flash[:error] = @post.errors.full_messages
      redirect_to edit_post_path(@post)
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.user == current_user
      @post.destroy
      flash[:success] = "The post is destroy!"
    else
      flash[:error] = "Solo el dueño puede borrar este post"
    end
    redirect_to posts_path
  end

  private

  def permit_post
    params.require(:post).permit(:image, :description)
  end
end
