module FileUtils

    def FileUtils.get_file_name(parser, episode_info, file_info)
        codec = file_info.extension == "mp4" ? "h264" : nil
    
        formatted_episode_number = "S#{episode_info.season_number}E#{episode_info.episode_number}"
    
        "#{parser.tv_show_file_name}.#{formatted_episode_number}.#{episode_info.title.gsub(" ", ".")}.#{file_info.resolution}p.#{parser.tv_show_source_name}.WEB-DL.#{codec != nil ? codec+"." : ""}#{file_info.extension}"
    end

    def FileUtils.get_file_path(parser, episode_info, file_info)
        file_name = FileUtils.get_file_name(parser, episode_info, file_info)
        season_dir_name = "Season #{episode_info.season_number}"

        BASE_TV_SHOW_DIR.join(parser.tv_show_directory_name).join(season_dir_name).join(file_name)
    end
end