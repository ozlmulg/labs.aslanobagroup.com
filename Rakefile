# encoding: utf-8

require "bundler/setup"
require "stringex"
require "yaml"

DATE_FORMAT = "%Y-%m-%d %H:%M"
NOW = Time.now.strftime(DATE_FORMAT)

task :default => [:serve]

desc "İlk kurulum (Lütfen önce bundle install yapın!)"
task :initialize do
  unless File.exists?('./_config.yml')
    system "cp ./_config.example.yml ./_config.yml"
    puts "Konfigürasyon dosyası kopyalandı!"
  end
  Rake::Task["serve"].invoke
end

task :serve do
  system "jekyll serve -w --host 0.0.0.0"
end

# rake post
# rake post["Başlık"]
# rake post["Başlık","2015-04-17 22:00"]
desc "Yeni blog post"
task :post, [:title, :post_date] do |t, args|
  title = args[:title] ? args[:title] : "Yeni Yazım"
  post_date = args[:post_date] ? DateTime.parse(args[:post_date]).strftime(DATE_FORMAT) : NOW
  preps = prep_file_post(post_date, title)
  filename = preps[:filename]
  content = preps[:content]
  filename_path = "_posts/#{filename}"
  raise "Bu dosya: #{filename} zaten var..." if File.exists? filename_path
  File.write filename_path, content
  puts "Yeni blog dosyası oluşturuldu: #{filename}"
end

# rake page["Etkinlikler","/etkinlikler/"]
desc "Yeni Sayfa"
task :page, [:title, :url] do |t, args|
  raise "Lütfen sayfanızın başlığını girin!" unless args[:title]
  raise "Lütfen oluşacak linki girin girin! Örnek: /sayfam/" unless args[:url]
  preps = prep_file_page(args[:title], args[:url])
  filename = preps[:filename]
  content = preps[:content]
  raise "Bu dosya: #{filename} zaten var..." if File.exists? filename
  File.write filename, content
  puts "Yeni sayfa oluşturuldu: #{filename}"
end

namespace :deploy do
  desc "Deploy (Rsync)"
  task :rsync do
    raise "_credentials.yml dosyası bulunamadı!" unless File.exists?('./_credentials.yml')
    secrets = YAML.load_file('./_credentials.yml')
    deploy_to ="#{secrets['user']}@#{secrets['server']}:#{secrets['path']}"
    rsync_str = "rsync -av _site/ #{deploy_to}"
    if secrets['port']
      rsync_str = "rsync -av -e \"ssh -p #{secrets['port']}\" _site/ #{deploy_to}"
    end
    ENV["JEKYLL_ENV"] = "production"
    system "jekyll build"
    system rsync_str
    puts "Rsync ile deploy işlemei tamamlandı!"
  end
end

def prep_file_page(title, url)
  filename = "#{url.gsub(/\//, "")}.md"
  output = ["---"]
  output << "layout: page"
  output << "title: \"#{title}\""
  output << "permalink: \"#{url}\""
  output << "header-img: \"images/example/about-bg.jpg\""
  output << "---"
  {
    filename: filename,
    content: output.join("\n")
  }
end

def prep_file_post(post_date, title)
  output = ["---"]
  output << "layout:        post"
  output << "title:         \"#{title}\""
  output << "subtitle:      \"Alt Başlık\""
  output << "date:          #{post_date}"
  output << "# tags:          [etiket1,etiket2]"
  output << "header-img:    \"images/example/post-bg.jpg\""
  output << "published:     true"
  output << "# posted_by:     Ad Soyad"
  output << "---"
  {
    filename: "#{post_date.gsub(/[ :]/, "-")}-#{title.to_url}.md",
    content: output.join("\n")
  }
end
