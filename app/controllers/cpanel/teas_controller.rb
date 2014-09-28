#encoding: utf-8 
require "fileutils"
class Cpanel::TeasController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/teas"
  before do; authenticate!; end

  # list
  # GET /cpanel/teas
  get "/" do
    @teas = Tea.all(:order => [:onsale.desc]) #:limit => 20

    haml :index, layout: :"../layouts/layout"
  end

  # new
  #get /cpanel/teas/new
  get "/new" do
    @tea = Tea.new
    @form_path   = "/cpanel/teas"
    @form_action = "post"

    haml :new, layout: :"../layouts/layout"
  end

  # create
  #post /cpanel/teas/{ teas: { }}
  post "/" do
    params.merge!({:onsale => false})
    @tea = Tea.create(params[:tea])

    redirect "/cpanel/teas?tea=%d" % @tea.id
  end

  # show
  # GET /cpanel/teas/1
  get "/:id" do
    @tea = Tea.all(:id => params[:id]).first

    haml :show, layout: :"../layouts/layout"
  end

  # edit
  # get /cpanel/teas/1/edit
  get "/:id/edit" do
    @tea = Tea.first(:id => params[:id])
    @form_path = "/cpanel/teas/#{@tea.id}"
    @form_action = "post"

    haml :edit, layout: :"../layouts/layout"
  end

  # update
  # patch /cpanel/teas/1
  post "/:id" do
    @tea = Tea.first(:id => params[:id])
    @tea.update(params[:tea].merge({ updated_at: DateTime.now }))

    redirect "/cpanel/teas?tea=%d" % @tea.id
  end

  # post /cpanel/teas/1/onsale
  # params: 
  # onsale - true/false
  # whether on sale
  post "/:id/onsale" do
    @tea = Tea.first(:id => params[:id])
    @tea.update({
      :onsale => params[:status],
      :updated_at => DateTime.now
    })

    redirect "/cpanel/teas?tea=%d" % @tea.id
  end

  #delete /cpanel/teas/1
  delete "/:id" do
    @tea = Tea.first(:id => params[:id])
    @tea.destroy
  end

  #upload image
  #post /cpanel/teas/1/image
  post "/:id/image" do
    @tea = Tea.first(:id => params[:id])

    image_name = params[:image][:filename].to_s
    image_data = params[:image][:tempfile].read

    image_dir = File.join(ENV["APP_ROOT_PATH"], "app/assets/images/teas", @tea.id.to_s)
    FileUtils.mkdir_p(image_dir) unless File.exist?(image_dir)

    image_path = File.join(image_dir, image_name)
    image_name = Time.now.strftime("%Y%m%d%H%M%S-") + image_name if File.exist?(image_path)
    File.open(File.join(image_dir, image_name), "wb") { |f| f.write(image_data) }

    @tea.update({
      :image => image_name,
      :updated_at => DateTime.now
    })

    redirect "/cpanel/teas?tea=%d" % @tea.id
  end
end
