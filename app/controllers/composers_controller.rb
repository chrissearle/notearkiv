class ComposersController < ApplicationController
  # GET /composers
  # GET /composers.json
  def index
    @composers = Composer.ordered

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @composers }
    end
  end

  # GET /composers/1
  # GET /composers/1.json
  def show
    @composer = Composer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @composer }
    end
  end

  # GET /composers/new
  # GET /composers/new.json
  def new
    @composer = Composer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @composer }
    end
  end

  # GET /composers/1/edit
  def edit
    @composer = Composer.find(params[:id])
  end

  # POST /composers
  # POST /composers.json
  def create
    @composer = Composer.new(params[:composer])

    respond_to do |format|
      if @composer.save
        format.html { redirect_to @composer, notice: 'Composer was successfully created.' }
        format.json { render json: @composer, status: :created, location: @composer }
      else
        format.html { render action: "new" }
        format.json { render json: @composer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /composers/1
  # PUT /composers/1.json
  def update
    @composer = Composer.find(params[:id])

    respond_to do |format|
      if @composer.update_attributes(params[:composer])
        format.html { redirect_to @composer, notice: 'Composer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @composer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /composers/1
  # DELETE /composers/1.json
  def destroy
    @composer = Composer.find(params[:id])
    @composer.destroy

    respond_to do |format|
      format.html { redirect_to composers_url }
      format.json { head :no_content }
    end
  end
end
