class MysqlBinsController < ApplicationController
  before_action :set_mysql_bin, only: [:show, :edit, :update, :destroy]

  authorize_resource

  def index
    if params[:user_id] && current_user.admin?
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end

    @mysql_bins = @user.mysql_bins.includes(:user).all
  end

  def show
    render layout: false
  end

  def new
    @mysql_bin = current_user.mysql_bins.create(queries: initial_queries, schema: initial_schema, title: "MySQL Query")
    redirect_to edit_mysql_bin_path(@mysql_bin)
  end

  def edit
    @mysql_runner = MysqlRunner.new(@mysql_bin)
    @mysql_runner.execute
  end

  def update
    respond_to do |format|
      if @mysql_bin.update(mysql_bin_params)
        format.html { redirect_to edit_mysql_bin_path(@mysql_bin, anchor: :output), notice: 'MysqlBin was successfully updated.' }
        format.json { render :show, status: :ok, location: @mysql_bin }
      else
        format.html { render :edit }
        format.json { render json: @mysql_bin.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @mysql_bin.destroy
    respond_to do |format|
      format.html { redirect_to mysql_bins_url, notice: 'MysqlBin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_mysql_bin
    @mysql_bin = MysqlBin.find(params[:id]) rescue nil
    unless @mysql_bin
      flash[:error] = "Page you are looking for doesn't exists."
      redirect_to_back_or_default
    end
  end

  # Never trust parameters from the scary INTERNET, only allow the white list through.
  def mysql_bin_params
    params.require(:mysql_bin).permit(:title, :queries, :schema)
  end

  def initial_queries
    "-- Using MySQL 5.7.30" +
    "\n-- Your Queries Here.\n"+
    "\n-- Do not include 'create database' statements. One db will be created for you. Just use tables you created in the schema tab.\n\n"
  end

  def initial_schema
    "-- Using MySQL 5.7.30" +
    "\n-- Your DB schma Here.\n"+
    "\n-- Do not include 'create database' statements. One db will be created for you. "
    "\n-- You can include create table, insert statements etc .. here.\n\n"
  end



end
