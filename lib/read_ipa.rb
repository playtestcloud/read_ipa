begin
  require 'zip/zip'
rescue LoadError
  require 'rubygems'
  require 'zip/zip'
end

require 'read_ipa/plist_binary'
require 'apple_png'
require 'chunky_png'

module ReadIpa
  class IpaFile
    attr_accessor :plist, :file_path
    def initialize(file_path)
      self.file_path = file_path
      @app_folder = Zip::ZipFile.foreach(file_path).find { |e| /.*\.app\/Info\.plist$/ =~ e.to_s }.to_s.gsub(/Info\.plist$/, '')
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

    def read_png(data)
      begin
        return ApplePng.new(data)
      rescue NotValidApplePngError
        return ChunkyPng::Image.from_datastream(ChunkyPNG::Datastream.from_blob(data))
      end
    end

    def get_highest_res_icon(icons_file_names)
      highest_res_icon = icons_file_names
        .map{ |icon_path| find_existing_path(icon_path) }
        .compact
        .uniq(&:name)
        .map{|entry| entry.get_input_stream.read}
        .max_by{|data| read_png(data).width }

      begin
        return ApplePng.new(highest_res_icon).data
      rescue NotValidApplePngError
        highest_res_icon
      end
    end

    def icon_file
      if plist["CFBundleIconFiles"]
        get_highest_res_icon(plist["CFBundleIconFiles"])
      elsif plist["CFBundleIcons"]
        dict = plist["CFBundleIcons"]
        primary_icons = dict["CFBundlePrimaryIcon"]
        return nil unless primary_icons
        icons = primary_icons.to_rb["CFBundleIconFiles"]
        return nil unless icons
        get_highest_res_icon(icons)
      elsif plist["CFBundleIconFile"]
        data = read_file(plist["CFBundleIconFile"])
        png = ApplePng.new(data)
        png.data
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

    def find_existing_path(icon_path)
      without_extension = icon_path.gsub(/\.png$/i, '')
      regex = /#{Regexp.quote(@app_folder)}#{Regexp.quote(without_extension)}[(\.png)@~]/
      @zipfile.entries.find{|e| e.name =~ regex}
    end

    private

    def read_file(entry)
      @zipfile.read(@app_folder + entry)
    end
  end
end
