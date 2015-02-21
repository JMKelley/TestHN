class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:index, :show]
  rescue_from Pundit::NotAuthorizedError, :with => :record_not_found

  # GET /links
  # GET /links.json
  def index

    @links = Link.all.order(:score)

    @days = [0, 1, 2, 3, 4, 5, 6, 7].collect do |i|
      date = Time.now - i.days
      [date, Link.where(created_at: date.beginning_of_day..date.end_of_day).order(:score)]
    end

    @days = @days.unshift({}).reduce do |memo, day|
      memo[day[0]] = day[1] if day[1].count > 0
      memo
    end
  end

  # GET /links/1
  # GET /links/1.json
  def show
    authorize @link
  end

  # GET /links/new
  def new
    @link = current_user.links.build
  end

  # GET /links/1/edit
  def edit
    authorize @link
  end

  # POST /links
  # POST /links.json
  def create

    params = link_creation_params

    @link = current_user.links.build({
      title: URI.unescape(params[:title]),
      image: URI.unescape(params[:thumbnail_url]),
      url: URI.unescape(params[:url]),
      description: URI.unescape(params[:description]),
      provider_name: URI.unescape(params[:provider_name]),
      provider_url: URI.unescape(params[:provider_url])
    })

    respond_to do |format|
      if @link.save
        format.html { redirect_to @link, notice: 'Link was successfully created.' }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
    
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    authorize @link
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to @link, notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    authorize @link
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url, notice: 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote
    @link = Link.find(params[:id])
    @link.upvote_by current_user unless @link.is_owner? current_user
    redirect_to :back
  end

  def downvote
    @link = Link.find(params[:id])
    @link.downvote_by current_user unless @link.is_owner? current_user
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
    end

    def record_not_found
      redirect_to links_url, :alert => "Couldn't find post"
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.require(:link).permit(:title, :url, :image, :description, :provider_name, :provider_url)
    end

    def link_creation_params
      params.permit(:link, :title, :url, :thumbnail_url, :description, :provider_name, :provider_url)
    end


end
