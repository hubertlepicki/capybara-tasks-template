require 'bundler'
require 'capybara/poltergeist'

Bundler.require

terms = ARGV.join(" ")

if terms == ""
  puts "Please specify a search term..."
  exit(-1)
end

puts "Searching for \"#{terms}\"..."


session = Capybara::Session.new(:poltergeist)
session.driver.headers = { "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.107 Safari/537.36" }

#session = Capybara::Session.new(:selenium)

session.visit "http://google.com"

session.fill_in "q", with: terms
if session.has_button?("gbqfb")
  session.click_button "gbqfb"
else
  session.click_button "Google Search"
end

if session.has_css?("#res")
  links = session.all("#res h3 a")
  links.each do |link|
    puts link.text
    puts link[:href]
    puts ""
  end
else
  puts "No results found"
  puts session.text
end
