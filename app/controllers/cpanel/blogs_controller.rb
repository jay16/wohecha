#encoding: utf-8 
require "cgi"
class Cpanel::BlogsController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/blogs"

  before do 
    authenticate!
    @post_path = "%s/source/_posts" % [Settings.octopress.path]
  end

  # get /cpanel/blogs
  get "/" do
    if File.exist?(@post_path)
      @markdowns = Dir.entries(@post_path).grep(/\.markdown$/)
      haml :index, layout: :"../layouts/layout"
    else
      @info = %Q(path not exist - #{@post_path})
      haml :error, layout: :"../layouts/layout"
    end
  end

  # get /cpanel/blogs/:post
  get "/:post" do
    @markdown_path = File.join(@post_path, params[:post])
    if File.exist?(@markdown_path)
      @content = IO.readlines(@markdown_path).join
      haml :show, layout: :"../layouts/layout"
    else
      @info = %Q(markdown not exist - #{@markdown_path})
      haml :error, layout: :"../layouts/layout"
    end
  end

  # scan
  # get /cpanel/blogs/:post/scan
  get "/:post/scan" do
    redirect blog_url_path(params[:post])
  end

  # create
  # post /cpanel/blogs
  post "/" do
    title = params[:title].strip
    shell_str = "cd %s && bundle exec rake new_post[%s]" % [Settings.octopress.path, title]
    status, *result = run_shell(shell_str)
    puts shell_str

    f_key = (status ? "success" : "danger").to_sym
    f_str = (status ? "成功!" : (["失败!"]+result).join("<br>"))
    flash[f_key] = "创建%s - [%s]" % [f_str, title]
    redirect "/cpanel/blogs"
  end

  # edit
  # get /cpanel/blogs/:post/edit
  get "/:post/edit" do
    @markdown_path = File.join(@post_path, params[:post])
    if File.exist?(@markdown_path)
      @content = CGI.unescapeHTML IO.readlines(@markdown_path).join
      haml :edit
    else
      @info = %Q(markdown not exist - #{@markdown_path})
      haml :error, layout: :"../layouts/layout"
    end
  end

  # update
  # post /cpanel/blogs/:post
  post "/:post" do
    markdown_path = File.join(@post_path, params[:post])
    File.open(markdown_path, "w+") { |file| file.puts(params[:content]) } 
    lines = IO.readlines(markdown_path).first(7)
    title = lines.grep(/^title:/).first.scan(/^title:\s+"(.*?)"/).flatten.first

    flash[:success] = "更新成功! - [%s]" % title
    redirect "/cpanel/blogs/#{params[:post]}"
  end

  # destroy
  # delete /cpanel/blogs/:post
  delete "/:post" do
    markdown_path = File.join(@post_path, params[:post])

    lines = IO.readlines(markdown_path).first(7)
    title = lines.grep(/^title:/).first.scan(/^title:\s+"(.*?)"/).flatten.first
    FileUtils.rm(markdown_path) if File.exist?(markdown_path)

    # remove images
    folder = params[:post][11..-1].sub(".markdown","")
    image_path = File.join(Settings.octopress.path, "source/images/posts", folder)
    FileUtils.rm_rf(image_path) if File.exist?(image_path)

    flash[:success] = "删除成功! - [%s]" % title
    redirect "/cpanel/blogs"
  end

  # octopress generate
  # /cpanel/blogs/octopress_generate
  post "/octopress_generate" do
    shell_str = "cd %s && bundle exec rake generate" % Settings.octopress.path
    status, *result = run_shell(shell_str)
    result.unshift(status == true ? "执行成功" : "执行失败")
    puts result

    f_key = (status ? "success" : "danger").to_sym
    flash[f_key] = "生成静态博文 - 执行" + (status == true ? "成功!" : "失败!")
    redirect "/cpanel/blogs"
  end

  # list images
  # get /cpanel/blogs/:post/images
  get "/:post/images" do
    post = params[:post].strip
    folder = post[11..-1].sub(".markdown","")
    image_folder = "%s/source/images/posts/%s" % [Settings.octopress.path, folder]
    FileUtils.mkdir_p(image_folder) unless File.exist?(image_folder)

    @images = Dir.entries(image_folder)
      .find_all { |img| %w[.png .jpg .jpeg .gif .bmp].include?(File.extname(img)) }
      .sort.map { |img| "/images/posts/%s/%s" % [folder, img] }

    haml :images
  end

  # add image
  # post /cpanel/blogs/:post/image
  post "/:post/image" do
    image_name = params[:image][:filename].to_s
    image_data = params[:image][:tempfile].read
    folder = params[:post][11..-1].sub(".markdown","")

    image_folder = "%s/source/images/posts/%s" % [Settings.octopress.path, folder]
    FileUtils.mkdir_p(image_folder) unless File.exist?(image_folder)

    image_path = File.join(image_folder, image_name)
    if File.exist?(image_path)
      flash[:warning] = "图片已经存在."
    else
      flash[:success] = "图片创建成功."
      File.open(image_path, "wb") { |f| f.write(image_data) }
    end

    redirect "/cpanel/blogs/%s/images" % params[:post]
  end

  private
    def blog_url_path(post)
      date  = post[0..9].gsub("-", "/")
      title = post[11..-1].sub(".markdown","")
      "%s/blog/%s/%s" % [Settings.octopress.website, date, title]
    end
end
