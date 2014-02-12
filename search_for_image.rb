require 'cgi'
require 'timeout'
require 'capybara'

class GoogleImagesSearcher
  include Capybara::DSL

  def initialize
    Capybara.default_driver = :selenium
  end

  def find_sites_with_image(image_url)
    urls = []


    link = "http://images.google.com/searchbyimage?image_url=#{CGI.escape(image_url)}&filter=0"

    visit link

    return urls unless page.has_content?("Pages that include matching images")

    while true
      page.all("h3.r a").each do |a|
        urls << a[:href]
      end
      within "#nav" do
        click_link "Next"
      end
    end
  rescue Capybara::ElementNotFound
    return urls.uniq
  rescue Timeout::Error => e
    return []
  rescue Encoding::UndefinedConversionError => e
    return []
  rescue Errno::ECONNRESET => e
    return []
  end
end

images = GoogleImagesSearcher.new.find_sites_with_image ARGV[0]

puts "Found #{images.count} pages using this image:"
images.each do |img|
  puts img
end
