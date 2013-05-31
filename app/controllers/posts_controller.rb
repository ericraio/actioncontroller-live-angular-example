class PostsController < ApplicationController
  include ActionController::Live
  respond_to :html, :json

  before_filter :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :like]
  before_filter :set_post, only: [:show, :edit, :update, :destroy, :like]

  # GET /posts/:slug
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/:slug/edit
  def edit
  end

  def feed
    respond_with current_user.followees_latest_posts
  end

  # POST /posts
  def create
    response.headers["Content-Type"] = "text/javascript"
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.save

      flash[:notice] = 'Post was successfully created.'
      if request.env['HTTP_REFERER'] == root_url
        redirect_to :back
      else
        redirect_to @post
      end
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /posts/:slug
  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      redirect_to :back
    end
  end

  # DELETE /posts/:slug
  #
  def destroy
    @post.destroy
    redirect_to :back, notice: 'Post was successfully destroyed.'
  end

  # GET /posts/notify
  #
  def notify
    return unless current_user
    event_stream('notify.*') do |data|
      user_id, post_id = data.split(',')
      post = Post.where(id: post_id)
      if post.user == current_user
        [User.where(id: user_id), post].to_json
      end
    end
    render json: {}
  end

  # POST /posts/:slug/like
  #
  def like
    return unless @post
    response.headers["Content-Type"] = "text/javascript"
    current_user.like(@post)
    $redis.publish('like', "#{current_user.id},#{@post.id}")
    render json: {}
  end

  # GET /posts/events
  #
  def events
    return unless current_user
    event_stream('messages.*') do |data|
      post = current_user.followees_latest_posts(where: { :created_at.gte => data }).first
      post.to_json if post
    end
    render json: {}
  end

  def event_stream(channel, &block)
    begin
      response.headers["Content-Type"] = "text/event-stream"
      redis = Redis.new
      redis.psubscribe(channel) do |on|
        on.pmessage do |pattern, event, data|
          response.stream.write("event: #{event}\n")
          response.stream.write("data: #{yield(data)}\n\n")
        end
      end
    rescue IOError
      logger.info("Stream closed")
    ensure
      redis.quit
      response.stream.close
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.where(slug: params[:slug]).first
  end

  # Only allow a trusted parameter "white list" through.
  def post_params
    params.require(:post).permit(:body, :headline)
  end
end
