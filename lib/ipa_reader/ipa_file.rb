begin
  require 'zip/zip'
rescue LoadError
  require 'rubygems'
  require 'zip/zip'
end

module IpaReader
  class IpaFile
    attr_accessor :plist, :file_path
    def initialize(file_path)
      self.file_path = file_path
      @app_folder = Zip::ZipFile.foreach(file_path).find { |e| /.*\.app\/$/ =~ e.to_s }.to_s
      @zipfile = Zip::ZipFile.open(file_path)

      cf_plist = CFPropertyList::List.new(:data => @zipfile.read(@app_folder + "Info.plist"), :format => CFPropertyList::List::FORMAT_BINARY)
      self.plist = cf_plist.value.to_rb
    end
    
    def version
      plist["CFBundleVersion"]
    end
    
    def name
      plist["CFBundleDisplayName"]
    end
    
    def target_os_version
      plist["DTPlatformVersion"].match(/[\d\.]*/)[0]
    end
    
    def minimum_os_version
      plist["MinimumOSVersion"].match(/[\d\.]*/)[0]
    end
    
    def url_schemes
      if plist["CFBundleURLTypes"] && plist["CFBundleURLTypes"][0] && plist["CFBundleURLTypes"][0]["CFBundleURLSchemes"]
        plist["CFBundleURLTypes"][0]["CFBundleURLSchemes"]
      else
        []
      end
    end
    
    def icon_file
      if plist["CFBundleIconFiles"]
        retina_icon = plist["CFBundleIconFiles"].find { |el| el.end_with?("@2x.png") }
        icon_path = retina_icon || plist["CFBundleIconFiles"][0]
        data = read_file(icon_path)
      elsif plist["CFBundleIconFile"]
        data = read_file(plist["CFBundleIconFile"])
      end
      if data
        IpaReader::PngFile.normalize_png(data)
      else
        nil
      end
    end
    
    def mobile_provision_file
      read_file("embedded.mobileprovision$")
    end
    
    def bundle_identifier
      puts plist["CFBundleIdentifier"].class
      plist["CFBundleIdentifier"]
    end
    
    def icon_prerendered
      plist["UIPrerenderedIcon"] == true
    end

    private

    def read_file(entry)
      @zipfile.read(@app_folder + entry)
    end
  end
end