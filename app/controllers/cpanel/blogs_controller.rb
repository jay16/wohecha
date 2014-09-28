#encoding: utf-8 
require "cgi"
class Cpanel::BlogsController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/blogs"

  before do 
    authenticate!
    @post_path = File.join(Settings.octopress.path, "source/_posts")
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
      #@markdown = params[:post]
      #@markdown.gsub!(".markdown", "")
      #markdown @markdown.to_sym, views: "app/views/cpanel/blogs/markdown", layout_engine: :haml, layout: :"../../layouts/layout"
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
  # post /cpanel/blogs/create
  post "/create" do
    title = params[:title].strip
    shell_str = %Q(cd #{Settings.octopress.path} && bundle exec rake new_post["#{title}"])
    status, *result = run_shell(shell_str)
    puts result

    f_key = (status ? "success" : "danger").to_sym
    flash[f_key] = title + " - 创建" + (status ? "成功!" : "失败!")
    redirect "/cpanel/blogs"
  end

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

  # update markdown
  # post /cpanel/blogs/:post
  post "/:post" do
    markdown_path = File.join(@post_path, params[:post])
    File.open(markdown_path, "w+") { |file| file.puts(params[:content]) } 
    lines = IO.readlines(markdown_path).first(7)
    title = lines.grep(/^title:/).first.scan(/^title:\s+"(.*?)"/).flatten.first

    flash[:success] = title + " - 更新成功!"
    redirect "/cpanel/blogs/#{params[:post]}"
  end

  # destroy markdown
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

    flash[:success] = title + " - 删除成功!"
    redirect "/cpanel/blogs"
  end

  post "/octopress_generate" do
    shell_str = %Q(cd #{Settings.octopress.path} && bundle exec rake generate)
    status, *result = run_shell(shell_str)
    result.unshift(status == true ? "执行成功" : "执行失败")
    puts result

    f_key = (status ? "success" : "danger").to_sym
    flash[f_key] = "生成静态博文 - 执行" + (status == true ? "成功!" : "失败!")
    redirect "/cpanel/blogs"
  end

  # add image
  # post /cpanel/blogs/:post/image
  post "/:post/image" do
    image_name = params[:image][:filename].to_s
    image_data = params[:image][:tempfile].read
    folder = params[:post][11..-1].sub(".markdown","")

    image_dir = File.join(Settings.octopress.path, "source/images/posts", folder)
    FileUtils.mkdir_p(image_dir) unless File.exist?(image_dir)

    image_path = File.join(image_dir, image_name)
    if File.exist?(image_path)
      flash[:warning] = "图片已经存在."
    else
      flash[:success] = "图片创建成功."
      File.open(File.join(image_dir, image_name), "wb") { |f| f.write(image_data) }
    end

    redirect "/cpanel/blogs/#{params[:post]}/images"
  end

  # get /cpanel/blog/:post/images
  get "/:post/images" do
    post = params[:post].strip
    folder = post[11..-1].sub(".markdown","")
    image_path = File.join(Settings.octopress.path, "source/images/posts", folder)
    FileUtils.mkdir_p(image_path) unless File.exist?(image_path)

    images = Dir.entries(image_path).find_all { |file| File.file?(File.join(image_path, file)) }
    @images = images.sort.map { |img| File.join("/images/posts", folder, img) }

    haml :images
  end

  private
    def blog_url_path(post)
      date  = post[0..9].gsub("-", "/")
      title = post[11..-1].sub(".markdown","")
      [Settings.octopress.website, "blog", date, title].join("/")
    end
end
