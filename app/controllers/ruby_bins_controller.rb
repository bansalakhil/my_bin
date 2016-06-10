class RubyBinsController < ApplicationController
  before_action :set_ruby_bin, only: [:show, :edit, :update, :destroy]

  authorize_resource

  def index
    @ruby_bins = current_user.ruby_bins.all
  end

  def show
    render layout: false
  end

  def new
    @ruby_bin = current_user.ruby_bins.create(code: initial_code, title: "Ruby Program")
    redirect_to edit_ruby_bin_path(@ruby_bin)
  end

  def edit
  end

  def update
    respond_to do |format|
      if @ruby_bin.update(ruby_bin_params)
        format.html { redirect_to edit_ruby_bin_path(@ruby_bin, anchor: :preview), notice: 'RubyBin was successfully updated.' }
        format.json { render :show, status: :ok, location: @ruby_bin }
      else
        format.html { render :edit }
        format.json { render json: @ruby_bin.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @ruby_bin.destroy
    respond_to do |format|
      format.html { redirect_to ruby_bins_url, notice: 'RubyBin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_ruby_bin
    @ruby_bin = RubyBin.find(params[:id]) rescue nil
    unless @ruby_bin
      flash[:error] = "Page you are looking for doesn't exists."
      redirect_to_back_or_default
    end
  end

  # Never trust parameters from the scary INTERNET, only allow the white list through.
  def ruby_bin_params
    params.require(:ruby_bin).permit(:title, :code, :tests)
  end

  def initial_code
    "# Your Ruby code here"
  end


end
