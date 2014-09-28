#encoding: utf-8
require "fileutils"
module BlogsHelper
  def octopress_parse(path, file)
    file_path = File.join(path, file)
    lines = IO.readlines(file_path).first(7)
    title = lines.grep(/^title:/).first.scan(/^title:\s+"(.*?)"/).flatten.first
    categories = lines.grep(/^categories:/).first.scan(/^categories:\s+\[(.*?)\]/).flatten.first
    return [title, categories]
  end

  def post_images(post)
    #2014-05-12-wu-dang-shan-long-jing-cha.markdown => wu-dang-shan-long-jing-cha
    #source/images/posts/wu-dang-shan-long-jing-cha/*.jpg
    folder = post[11..-1].sub(".markdown","")
    image_path = File.join(Settings.octopress.path, "source/images/posts", folder)
    FileUtils.mkdir_p(image_path) unless File.exist?(image_path)

    images = Dir.entries(image_path).find_all { |file| File.file?(File.join(image_path, file)) }
    images.sort.map { |img| File.join("/images/posts", folder, img) }
  end

  def img_url_path(relative_path)
    [Settings.octopress.website, relative_path].join
  end

end
