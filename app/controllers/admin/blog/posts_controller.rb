# Admin controller for blog posts
class Admin::Blog::PostsController < AdminController
  before_action :set_blog
  before_action :set_post_for_create, only: %i[ create ]
  before_action :set_post, only: %i[ edit update destroy ]
  after_action :verify_authorized

  def index
    page_num = params[ :page ] || 1
    @posts = @blog.all_posts.order( :created_at ).page( page_num )
    # authorise @posts
    skip_authorization  # TODO: FIXME
  end

  def new
    @post = @blog.posts.new
    authorise @post
  end

  def create
    authorise @post

    if @post.save
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, blog_id: @blog.id, id: @post.id
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :new
    end
  end

  def edit
    authorise @post
  end

  def update
    authorise @post

    if @post.update( post_params )
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @post.id
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :edit
    end
  end

  def destroy
    authorise @post

    flash[ :notice ] = t( '.success' ) if @post.destroy
    redirect_to action: :index
  end

  private

  def set_blog
    @blog =
      if Blog.multiple_blogs_mode
        # :nocov:
        Blog.find( params[:id] )
        # :nocov:
      else
        Blog.all.first
      end
  end

  def set_post
    @post = @blog.posts.find( params[:id] )
  rescue ActiveRecord::RecordNotFound
    skip_authorization
    redirect_with_alert blog_posts_path, t( '.failure' )
  end

  def post_params
    unless current_user.can? :change_author, :blog_posts
      params[ :blog_post ].delete( :user_id )
    end

    params.require( :blog_post ).permit(
      :blog_id, :user_id, :title, :slug, :posted_at, :body, :hidden
    )
  end

  def set_post_for_create
    @post = @blog.posts.new( post_params_for_create )
  end

  def post_params_for_create
    unless current_user.can? :change_author, :blog_posts
      params[ :blog_post ][ :user_id ] = current_user.id
    end

    params.require( :blog_post ).permit(
      :blog_id, :user_id, :title, :slug, :posted_at, :body, :hidden
    )
  end
end