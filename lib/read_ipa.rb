begin
  require 'zip/zip'
rescue LoadError
  require 'rubygems'
  require 'zip/zip'
end

require 'read_ipa/plist_binary'
require 'read_ipa/png_file'

module ReadIpa
  class IpaFile
    attr_accessor :plist, :file_path
    def initialize(file_path)
      self.file_path = file_path
      @app_folder = Zip::ZipFile.foreach(file_path).find { |e| /.*\.app\/$/ =~ e.to_s }.to_s
      @zipfile = Zip::ZipFile.open(file_path)

      cf_plist = CFPropertyList::List.new(data: @zipfile.read(@app_folder + "Info.plist"), format: CFPropertyList::List::FORMAT_AUTO)
      self.plist = cf_plist.value.to_rb
    end

    def version
      plist["CFBundleVersion"]
    end

    def short_version
      plist["CFBundleShortVersionString"]
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
        highest_res_icon = plist["CFBundleIconFiles"]
          .map{ |icon|
            data = read_file(icon)
            ReadIpa::PngFile.new(data)
          }
          .sort{ |a,b| b.width <=> a.width }
          .first
        highest_res_icon.raw_data
      elsif plist["CFBundleIconFile"]
        data = read_file(plist["CFBundleIconFile"])
        png = ReadIpa::PngFile.new(data)
        png.raw_data
      else
        nil
      end
    end

    def executable_file_name
      plist["CFBundleExecutable"]
    end

    def executable_file
      read_file(executable_file_name)
    end

    def mobile_provision_file
      read_file("embedded.mobileprovision")
    end

    def bundle_identifier
      plist["CFBundleIdentifier"]
    end

    def icon_prerendered
      plist["UIPrerenderedIcon"] == true
    end

    def for_ipad?
      return true if plist["UIDeviceFamily"] && (plist["UIDeviceFamily"] == 2 || plist["UIDeviceFamily"].include?(2))
      return true if plist["UIDeviceFamily"] && (plist["UIDeviceFamily"] == "2" || plist["UIDeviceFamily"].include?("2"))
      return false
    end

    def for_iphone?
      return true if !plist["UIDeviceFamily"]
      return true if plist["UIDeviceFamily"] == 1 || plist["UIDeviceFamily"].include?(1)
      return true if plist["UIDeviceFamily"] == "1" || plist["UIDeviceFamily"].include?("1")
      return false
    end

    private

    def read_file(entry)
      @zipfile.read(@app_folder + entry)
    end
  end
end
