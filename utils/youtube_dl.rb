require './models/file_info'

class YoutubeDL

    def initialize(parser)
        cookies_parameter = parser.relative_cookies_file_path != nil ? "--cookies #{parser.relative_cookies_file_path}" : ""
        @base_cmd = "youtube-dl #{cookies_parameter}"
    end

    def get_file_info(url)
        file_info_json = %x(#{@base_cmd} --quiet --no-warnings --dump-json #{url})

        if file_info_json == nil
            raise "Could not get file info from youtube-dl for #{url}"
        end

        file_info = JSON.parse(file_info_json.chomp)

        FileInfo.new(file_info["ext"], file_info["height"])
    end

    def download_file(file_path, url)
        %x(#{@base_cmd} -o "#{file_path}" #{url})
    end
end