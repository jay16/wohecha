require "fileutils"

desc "around tea"
namespace :tea do
  desc "replace images to teas/:id"
  task :replace_image => :environment do
    teas = Tea.all
    old_image_dir = File.join(ENV["APP_ROOT_PATH"], "app/assets/images")
    new_image_dir = File.join(old_image_dir, "teas")

    teas.each do |tea|
      next if tea.image.nil?
      old_image_path = File.join(old_image_dir, tea.image)
      new_image_path = File.join(new_image_dir, tea.id.to_s, tea.image)
      FileUtils.mkdir_p(new_image_path) if not File.exist?(new_image_path)

      if File.exist?(old_image_path)
        FileUtils.mv(old_image_path, new_image_path)
        puts [old_image_path, new_image_path].join(" => ")
        puts "yes" if File.exist?(new_image_path)
      else
        puts "Error: " + old_image_path
      end

    end
  end

  desc "create teas"
  task :init => :environment do
    IO.readlines("./tea.txt").each do |line|
      array = line.split
      hash = {
        :name => array[0],
        :image => array[1],
        :from => array[2],
        :price => array[3],
        :unit1 => array[4],
        :unit2 => array[5],
        :weight => array[6],
        :unit3 => array[7],
        :desc => array[8]
      }
      tea = Tea.create(hash)
      puts "create:"+ tea.inspect
    end
  end
end
