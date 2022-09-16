require 'active_support/core_ext/object'
require 'cfpropertylist'

module ReadIpa
  class InfoPlist
    def initialize(plist_str)
      @plist = CFPropertyList::List.new(data: plist_str, format: CFPropertyList::List::FORMAT_AUTO).value.to_rb
    end

    def version
      @plist["CFBundleVersion"]
    end

    def short_version
      @plist["CFBundleShortVersionString"]
    end

    def name
      @plist["CFBundleDisplayName"].presence || @plist["CFBundleName"]
    end

    def target_os_version
      @plist["DTPlatformVersion"].match(/[\d\.]*/)[0] if @plist["DTPlatformVersion"]
    end

    def minimum_os_version
      @plist["MinimumOSVersion"].match(/[\d\.]*/)[0] if @plist["MinimumOSVersion"]
    end

    def url_schemes
      @plist.dig('CFBundleURLTypes', 0, 'CFBundleURLSchemes') || []
    end

    def icon_files
      icon_files = [@plist["CFBundleIconFile"]].compact
      icon_files += @plist["CFBundleIconFiles"] || []
      if @plist["CFBundleIcons"]
        dict = @plist["CFBundleIcons"]
        primary_icons = dict["CFBundlePrimaryIcon"]
        return nil unless primary_icons
        icons = primary_icons.to_rb["CFBundleIconFiles"]
        return nil unless icons
        icon_files += icons
      end
      icon_files
    end

    def executable_file_name
      @plist["CFBundleExecutable"]
    end

    def bundle_identifier
      @plist["CFBundleIdentifier"]
    end

    def icon_prerendered
      @plist["UIPrerenderedIcon"] == true
    end

    def for_ipad?
      return false if @plist["UIDeviceFamily"].nil?
      if @plist["UIDeviceFamily"].kind_of?(Array)
        return true if @plist["UIDeviceFamily"] && (@plist["UIDeviceFamily"].include?(2) || @plist["UIDeviceFamily"].include?("2"))
      else
        return true if @plist["UIDeviceFamily"] && (@plist["UIDeviceFamily"] == 2 || @plist["UIDeviceFamily"] == "2")
      end
      return false
    end

    def for_iphone?
      return true if @plist["UIDeviceFamily"].nil?
      if @plist["UIDeviceFamily"].kind_of?(Array)
        return true if @plist["UIDeviceFamily"].include?(1) || @plist["UIDeviceFamily"].include?("1")
      else
        return true if @plist["UIDeviceFamily"] == 1 || @plist["UIDeviceFamily"] == "1"
      end
      return false
    end

    def get_property(property_name)
      @plist.fetch(property_name, nil)
    end
  end
end
