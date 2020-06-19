class JsBinsController < ApplicationController
  before_action :set_js_bin, only: [:show, :edit, :update, :destroy, :qunit]

  authorize_resource

  # GET /js_bins
  # GET /js_bins.json
  def index
    if params[:user_id] && current_user.admin?
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end

    @js_bins =   @user.js_bins.includes(:user).all
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
    params.require(:js_bin).permit(:html, :css, :js, :title, :tests, :js_init)
  end

  def html
    '
<!doctype html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">

    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

    <title>Hello, world!</title>
  </head>
  <body>
    <div class="container shadow">
      <!-- Content here -->

      <h1>Hello, world!</h1>
    </div>
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
