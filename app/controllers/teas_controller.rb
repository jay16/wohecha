#encoding: utf-8 
require "fileutils"
class TeasController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/teas"

  before do
    authenticate!
  end

  # GET /teas
  get "/" do
    @teas = Tea.all

    haml :list, layout: :"../layouts/layout"
  end

  #get /teas/new
  get "/new" do
    @tea = Tea.new
    @form_path = "/teas/create"

    haml :new, layout: :"../layouts/layout"
  end
  #post /teas/create { teas: { }}
  post "/create" do
    params.merge!({:onsale => false})
    @tea = Tea.create(params[:tea])

    redirect "/teas?tea=#{@tea.id}" 
  end

  # GET /teas/1
  get "/:id" do
    @tea = Tea.all(:id => params[:id]).first

    haml :show, layout: :"../layouts/layout"
  end

  #get /teas/1/edit
  get "/:id/edit" do
    @tea = Tea.first(:id => params[:id])
    @form_path = "/teas/#{@tea.id}/update"
    
    haml :edit, layout: :"../layouts/layout"
  end

  #post /teas/1/update
  post "/:id/update" do
    @tea = Tea.first(:id => params[:id])
    @tea.update(params[:tea])

    redirect "/teas?tea=#{@tea.id}"
  end

  # post /teas/1/onsale
  # params: 
  # onsale - true/false
  # whether on sale
  post "/:id/onsale" do
    @tea = Tea.first(:id => params[:id])
    @tea.update(:onsale => params[:status])

    redirect "/teas?tea=#{@tea.id}"
  end

  #delete /teas/1
  delete "/:id" do
    @tea = Tea.first(:id => params[:id])
    @tea.destroy
  end

  #upload image
  #post /teas/1/image
  post "/:id/image" do
    @tea = Tea.first(:id => params[:id])

    image_name = params[:image][:filename].to_s
    image_data = params[:image][:tempfile].read

    image_dir = File.join(ENV["APP_ROOT_PATH"], "app/assets/images")
    FileUtils.mkdir_p(image_dir) unless File.exist?(image_dir)

    image_path = File.join(image_dir, image_name)
    image_name = Time.now.strftime("%Y%m%d%H%M%S-") + image_name if File.exist?(image_path)
    File.open(File.join(image_dir, image_name), "wb") { |f| f.write(image_data) }

    @tea.update(:image => image_name)

    redirect "/teas"
  end
end
