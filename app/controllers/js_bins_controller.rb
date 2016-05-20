class JsBinsController < ApplicationController
  before_action :set_js_bin, only: [:show, :edit, :update, :destroy]

  # GET /js_bins
  # GET /js_bins.json
  def index
    @js_bins = JsBin.all
  end

  # GET /js_bins/1
  # GET /js_bins/1.json
  def show
    render layout: false
  end

  # GET /js_bins/new
  def new
    @js_bin = JsBin.create(html: html, js: js, css: css, title: "Title")
    redirect_to edit_js_bin_path(@js_bin)
  end

  # GET /js_bins/1/edit
  def edit
  end

  # POST /js_bins
  # POST /js_bins.json
  def create
    @js_bin = JsBin.new(js_bin_params)

    respond_to do |format|
      if @js_bin.save
        format.html { redirect_to @js_bin, notice: 'Js bin was successfully created.' }
        format.json { render :show, status: :created, location: @js_bin }
      else
        format.html { render :new }
        format.json { render json: @js_bin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /js_bins/1
  # PATCH/PUT /js_bins/1.json
  def update
    respond_to do |format|
      if @js_bin.update(js_bin_params)
        format.html { redirect_to edit_js_bin_path(@js_bin), notice: 'Js bin was successfully updated.' }
        format.json { render :show, status: :ok, location: @js_bin }
      else
        format.html { render :edit }
        format.json { render json: @js_bin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /js_bins/1
  # DELETE /js_bins/1.json
  def destroy
    @js_bin.destroy
    respond_to do |format|
      format.html { redirect_to js_bins_url, notice: 'Js bin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_js_bin
      @js_bin = JsBin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def js_bin_params
      params.require(:js_bin).permit(:html, :css, :js, :title)
    end

    def html
      '
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-1.11.3.js"></script>

  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width">
  <title>JS Bin</title>
</head>
<body>
<p> 
  hello there
</p>  
</body>
</html>

    '
  end

  def js
    '
$(function() {
    console.log( "ready!" );
    $("p").css("color", "red");

});
    '
  end

  def css
    '
p{
  color: green;
}
    '
  end

end
