
class EpisodeInfo

    attr_accessor :episode_number
    attr_accessor :url
    attr_accessor :season_number
    attr_accessor :title

    def initialize(episode_number, season_number, title, url)
        @episode_number = episode_number
        @url = url
        @season_number = season_number
        @title = title
    end

    def to_s
        "Season Number: #{@season_number}, Episode Number: #{@episode_number}, Title: #{@title}, URL: #{@url}"
    end

end
