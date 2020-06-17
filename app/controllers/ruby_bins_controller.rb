class RubyBinsController < ApplicationController
  before_action :set_ruby_bin, only: [:show, :edit, :update, :destroy]

  authorize_resource

  def index
    if params[:user_id] && current_user.admin?
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end

    @ruby_bins = @user.ruby_bins.includes(:user).all
  end

  def show
    render layout: false
  end

  def new
    @ruby_bin = current_user.ruby_bins.create(code: initial_code, title: "Ruby Program")
    redirect_to edit_ruby_bin_path(@ruby_bin)
  end

  def edit
    @ruby_runner = RubyRunner.new(@ruby_bin)
    @ruby_runner.execute
  end

  def update
    respond_to do |format|
      if @ruby_bin.update(ruby_bin_params)
        format.html { redirect_to edit_ruby_bin_path(@ruby_bin, anchor: :output), notice: 'RubyBin was successfully updated.' }
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
    params.require(:ruby_bin).permit(:title, :code, :tests, :input)
  end

  def initial_code
    "# Using Ruby version: ruby 2.7.1p83 (2020-03-31 revision a0c7c23c9c) [x86_64-linux]" +
    "\n# Your Ruby code here"
  end


end
