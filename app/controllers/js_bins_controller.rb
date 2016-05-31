class JsBinsController < ApplicationController
  before_action :set_js_bin, only: [:show, :edit, :update, :destroy, :qunit]

  authorize_resource

  # GET /js_bins
  # GET /js_bins.json
  def index
    @js_bins = current_user.js_bins.all
  end

  # GET /js_bins/1
  # GET /js_bins/1.json
  def show
    render layout: false
  end

  # GET /js_bins/new
  def new
    @js_bin = current_user.js_bins.create(html: html, js: js, css: css, title: "Title")
    redirect_to edit_js_bin_path(@js_bin)
  end

  def qunit
    @page_title = @js_bin.title
    render layout: 'qunit'
  end

  # GET /js_bins/1/edit
  def edit
  end

  # PATCH/PUT /js_bins/1
  # PATCH/PUT /js_bins/1.json
  def update
    respond_to do |format|
      if @js_bin.update(js_bin_params)
        format.html { redirect_to edit_js_bin_path(@js_bin, anchor: :preview), notice: 'Js bin was successfully updated.' }
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
    @js_bin = JsBin.find(params[:id]) rescue nil
    unless @js_bin
      flash[:error] = "Page you are looking for doesn't exists."
      redirect_to_back_or_default
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def js_bin_params
    params.require(:js_bin).permit(:html, :css, :js, :title, :tests)
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
