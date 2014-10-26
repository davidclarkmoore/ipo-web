class LessionsController < ApplicationController
  # GET /lessions
  # GET /lessions.json
  def index
    @lessions = Lession.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lessions }
    end
  end

  # GET /lessions/1
  # GET /lessions/1.json
  def show
    @lession = Lession.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lession }
    end
  end

  # GET /lessions/new
  # GET /lessions/new.json
  def new
    @lession = Lession.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lession }
    end
  end

  # GET /lessions/1/edit
  def edit
    @lession = Lession.find(params[:id])
  end

  # POST /lessions
  # POST /lessions.json
  def create
    @lession = Lession.new(params[:lession])

    respond_to do |format|
      if @lession.save
        format.html { redirect_to @lession, notice: 'Lession was successfully created.' }
        format.json { render json: @lession, status: :created, location: @lession }
      else
        format.html { render action: "new" }
        format.json { render json: @lession.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lessions/1
  # PUT /lessions/1.json
  def update
    @lession = Lession.find(params[:id])

    respond_to do |format|
      if @lession.update_attributes(params[:lession])
        format.html { redirect_to @lession, notice: 'Lession was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lession.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lessions/1
  # DELETE /lessions/1.json
  def destroy
    @lession = Lession.find(params[:id])
    @lession.destroy

    respond_to do |format|
      format.html { redirect_to lessions_url }
      format.json { head :no_content }
    end
  end
end
