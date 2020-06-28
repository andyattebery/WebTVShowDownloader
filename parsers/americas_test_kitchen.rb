require './models/models'

class AmericasTestKitchenParser

    def relative_cookies_file_path
        "Cookies/atk-cookies.txt"
    end

    def tv_show_source_name
        "ATK"
    end

    def tv_show_directory_name
        "America's Test Kitchen"
    end

    def tv_show_file_name
        "Americas.Test.Kitchen"
    end

    def get_episode_nodes(html_document)
        html_document.css(".result__content")
    end

    def create_episode_info(node)
        episode_link_node = node.css(".result__episode-link")[0]
        raw_number = episode_link_node["title"]
        link = episode_link_node["href"]
        title = node.css(".result__title-link")[0]["title"]

        unless /Season (\d+), Ep (\d+)/ =~ raw_number
            raise "Could not parse episode number."
        end

        season_number = "%02d" % Regexp.last_match.captures[0]
        raw_episode_number = "%04d" % Regexp.last_match.captures[1]
        unless /\d\d(\d\d)/ =~ raw_episode_number
            raise "Could not parse episode number."
        end

        episode_number = Regexp.last_match.captures[0]

        url = "https://www.americastestkitchen.com#{link}"

        EpisodeInfo.new(episode_number, season_number, title, url)
    end
end
