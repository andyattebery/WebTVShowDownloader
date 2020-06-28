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
require 'yaml'

require 'nokogiri'
require 'parallel'

require './models/models'
require './parsers/parsers'
require './utils/utils'

# Arguments
url = ARGV[0]

if url == nil
    puts "No season URL specified."
    exit
end

# Config
config = YAML.load_file('config.yml')

BASE_TV_SHOW_DIR = Pathname.new(config["base_tv_show_directory"])

# Dependencies
parser = case url
when /americastestkitchen/
    AmericasTestKitchenParser.new(config)
when /177milkstreet/
    OneSevenSevenMilkStreetParser.new(config)
end

youtube_dl = YoutubeDL.new(parser)

# Main
html_page = Nokogiri::HTML(URI.open(url))

episode_nodes = parser.get_episode_nodes(html_page)

episode_nodes = episode_nodes[0, 1]

Parallel.each(episode_nodes.to_a) do |node|
    
    begin
        episode_info = parser.create_episode_info(node)
    rescue => exception
        puts "Could not get episode info. Exception: #{exception}"
        next
    end

    begin
        file_info = youtube_dl.get_file_info(episode_info.url)
    rescue => exception
        puts "Could not get file info. Exception: #{exception}"
        next
    end

    file_path = FileUtils.get_file_path(parser, episode_info, file_info)

    if File.exists? file_path
        puts "#{file_path} already exists."
        next
    end

    puts youtube_dl.download_file(file_path, episode_info.url)
end
