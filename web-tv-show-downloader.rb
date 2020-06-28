#!/usr/bin/env ruby

require 'bundler/inline'

gemfile do
    source 'https://rubygems.org'
    gem 'nokogiri'
    gem 'parallel'
end

require 'rubygems'
require 'json'
require 'open-uri'
require 'pathname'

require 'nokogiri'
require 'parallel'

require './models/models'
require './parsers/parsers'

TV_SHOW_DIR = Pathname.new("/Volumes/Storage/TV Shows")

url = ARGV[0]

if url == nil
    puts "No season URL specified."
    exit
end

parser = case url
when /americastestkitchen/
    AmericasTestKitchenParser.new
end

html_page = Nokogiri::HTML(URI.open(url))

episode_nodes = parser.get_episode_nodes(html_page)

episode_nodes = episode_nodes.to_a[20, 1]

def get_file_name(parser, episode_info, resolution, extension)
    codec = extension == "mp4" ? "h264" : nil

    formatted_episode_number = "S#{episode_info.season_number}E#{episode_info.episode_number}"

    "#{parser.tv_show_file_name}.#{formatted_episode_number}.#{episode_info.title.gsub(" ", ".")}.#{resolution}p.#{parser.tv_show_source_name}.WEB-DL.#{codec != nil ? codec+"." : ""}#{extension}"
end

Parallel.each(episode_nodes.to_a) do |node|
    
    begin
        episode_info = parser.create_episode_info(node)
    rescue => exception
        puts "Could not get episode info. Exception: #{exception}"
        next
    end

    cookies_parameter = parser.relative_cookies_file_path != nil ? "--cookies #{parser.relative_cookies_file_path}" : ""

    file_info_json = %x(youtube-dl #{cookies_parameter} --dump-json #{episode_info.url})

    if file_info_json == nil
        puts "Could not get file info from youtube-dl for #{episode_info.url}"
        next
    end

    begin
        file_info = JSON.parse(file_info_json.chomp)
    rescue => exception
        puts "Could not get file info from youtube-dl for #{episode_info.url}"
        puts exception
        next
    end

    file_resolution = file_info["height"]
    file_extension = file_info["ext"]

    file_name = get_file_name(parser, episode_info, file_resolution, file_extension)
    season_dir_name = "Season #{episode_info.season_number}"

    file_path = TV_SHOW_DIR.join(parsers.tv_show_directory_name).join(season_dir_name).join(file_name)

    if File.exists? file_path
        puts "#{file_path} already exists."
        next
    end

    puts %x(youtube-dl #{cookies_parameter} -o "#{file_path}" #{episode_info.url})
end
