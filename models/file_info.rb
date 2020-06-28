class FileInfo

    attr_accessor :extension
    attr_accessor :resolution
    
    def initialize(extension, resolution)
        @extension = extension
        @resolution = resolution
    end
end