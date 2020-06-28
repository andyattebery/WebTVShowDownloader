require './models/models'

class OneSevenSevenMilkStreetParser

    def relative_cookies_file_path
        "cookies/177-milk-street-cookies.txt"
    end

    def tv_show_source_name
        "MLKSTRT"
    end

    def tv_show_directory_name
        "177 Milk Street"
    end

    def tv_show_file_name
        "177.Milk.Street"
    end

    def get_episode_nodes(html_document)
        html_document.css(".article-card")
    end

    def create_episode_info(node)
        episode_link_node = node.css(".article-card__video-link")[0]
        link = episode_link_node["href"]

        raw_number = node.css(".tv__meta")[0].text
        
        title = node.css("h3")[0].text

        unless /Season (\d+), Episode (\d+)/ =~ raw_number
            raise "Could not parse episode number."
        end

        season_number = "%02d" % Regexp.last_match.captures[0]
        episode_number = "%02d" % Regexp.last_match.captures[1]

        EpisodeInfo.new(episode_number, season_number, title, link)
    end
end
