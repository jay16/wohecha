#encoding: utf-8 
require "cgi"
class BlogsController < ApplicationController
  set :views, ENV["VIEW_PATH"] + "/blogs"

  before do 
    authenticate!
    @post_path = File.join(Settings.octopress.path, "source/_posts")
  end

  # /blogs
  get "/" do
    if File.exist?(@post_path)
      @markdowns = Dir.entries(@post_path).grep(/\.markdown$/)
      haml :index, layout: :"../layouts/layout"
    else
      @info = %Q(path not exist - #{@post_path})
      haml :error, layout: :"../layouts/layout"
    end
  end

  # /blogs/show
  get "/show" do
    @markdown_path = File.join(@post_path, params[:post])
    if File.exist?(@markdown_path)
      @content = IO.readlines(@markdown_path).join
      haml :show, layout: :"../layouts/layout"
    else
      @info = %Q(markdown not exist - #{@markdown_path})
      haml :error, layout: :"../layouts/layout"
    end
  end

  post "/create" do
    title = params[:title].strip
    shell_str = %Q(cd #{Settings.octopress.path} && bundle exec rake new_post["#{title}"])
    status, *result = run_shell(shell_str)
    puts result

    f_key = (status ? "success" : "danger").to_sym
    flash[f_key] = title + " - 创建" + (status ? "成功!" : "失败!")
    redirect "/blogs"
  end

  # get /blogs/edit
  get "/edit" do
    @markdown_path = File.join(@post_path, params[:post])
    if File.exist?(@markdown_path)
      @content = CGI.unescapeHTML IO.readlines(@markdown_path).join
      haml :edit
    else
      @info = %Q(markdown not exist - #{@markdown_path})
      haml :error, layout: :"../layouts/layout"
    end
  end

  # post /blogs/update
  post "/update" do
    markdown_path = File.join(@post_path, params[:post])
    File.open(markdown_path, "w+") { |file| file.puts(params[:content]) } 
    lines = IO.readlines(markdown_path).first(7)
    title = lines.grep(/^title:/).first.scan(/^title:\s+"(.*?)"/).flatten.first

    flash[:success] = title + " - 更新成功!"
    redirect "/blogs"
  end

  # delete /blogs/remove
  delete "/remove" do
    # remove markdown
    markdown_path = File.join(@post_path, params[:post])

    lines = IO.readlines(markdown_path).first(7)
    title = lines.grep(/^title:/).first.scan(/^title:\s+"(.*?)"/).flatten.first
    FileUtils.rm(markdown_path) if File.exist?(markdown_path)

    # remove images
    folder = params[:post][11..-1].sub(".markdown","")
    image_path = File.join(Settings.octopress.path, "source/images/posts", folder)
    FileUtils.rm_rf(image_path) if File.exist?(image_path)

    flash[:success] = title + " - 删除成功!"
    redirect "/blogs"
  end

  post "/octopress_generate" do
    shell_str = %Q(cd #{Settings.octopress.path} && bundle exec rake generate)
    status, *result = run_shell(shell_str)
    result.unshift(status == true ? "执行成功" : "执行失败")
    puts result

    f_key = (status ? "success" : "danger").to_sym
    flash[f_key] = "生成静态博文 - 执行" + (status == true ? "成功!" : "失败!")
    redirect "/blogs"
  end

  post "/image" do
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

    # reload the image frame
    redirect "/blogs/images?post=#{params[:post]}"
  end

  # get /blog/images
  get "/images" do
    post = params[:post].strip
    folder = post[11..-1].sub(".markdown","")
    image_path = File.join(Settings.octopress.path, "source/images/posts", folder)
    FileUtils.mkdir_p(image_path) unless File.exist?(image_path)

    images = Dir.entries(image_path).find_all { |file| File.file?(File.join(image_path, file)) }
    @images = images.sort.map { |img| File.join("/images/posts", folder, img) }

    haml :images
  end

end
