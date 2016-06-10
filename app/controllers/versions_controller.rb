class VersionsController < ApplicationController
  before_action :set_resource

  def show
    
    @version = @resource.versions.find_by(id: params[:id])
    authorize! :show, @resource
  end


  private

  def set_resource
    klass = [JsBin, RubyBin].detect{|c| params["#{c.name.underscore}_id"]}
    @resource = klass.find(params["#{klass.name.underscore}_id"])

    unless @resource
      flash[:error] = "Page not found."
      redirect_to :back
    end
  end
end
