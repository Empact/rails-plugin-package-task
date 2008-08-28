#!/usr/bin/env ruby

require 'rake'
require 'rake/tasklib'

module Rake
  # RailsPluginPackageTask defines the "rails_plugin" task
  # that recurses through your _package_files_, generates compliant index.html for
  # each folder (that contains a file), and creates a directory structure that you
  # can publish as a set for your plugin.
  # 
  # Noteworthy attributes:
  # 
  # [package_dir]  Directory to store the package. Default 'pkg/rails_plugin'
  #   
  # [package_dir]  Files to include in the plugin.
  #   
  # [extra_links]  Links to put on every generated index page. Can be a hash, e.g.
  #                {"Home"=>"http://roxml.rubyforge.org"}, an array of strings or
  #                a single string.
  #                  
  # [plugin_files]  Files to be placed in the root folder of the plug-in, e.g.
  #                 init.rb. All files that are in the root of _package_dir_
  #                 will also be placed in the root of the plug-in.
  #                   
  class RailsPluginPackageTask < TaskLib
    # Name of plug-in or application
    attr_accessor :name
    # Version of plugin - distribution folder will be name_version
    attr_accessor :version
    # Directory used to store the package files (default is 'pkg/rails_plugin').
    attr_accessor :package_dir
    # Files to be stored in the package
    attr_accessor :package_files
    # Files to go into the root of the plug-in folder (e.g. init.rb)
    attr_accessor :plugin_files
    # Homepage for more information
    attr_accessor :extra_links
    # Verbose [true | false]
    attr_accessor :verbose

    # Create the "rails_plugin" task
    def initialize(name=nil, version=nil)
      init(name, version)
      yield self if block_given?
      define unless name.nil?
    end

    # Initialize with defaults
    def init(name, version)
      @name = name
      @version = version
      @extra_links = nil
      @package_files = Rake::FileList.new
      @plugin_files = Rake::FileList.new
      @package_dir = 'pkg/rails_plugin'
      @folders = {}
      @verbose = false
    end
    
    # Define the rails_plugin task
    def define
      desc "Create Ruby on Rails plug-in package"
      task :rails_plugin do
        @dest = "#@package_dir/#{@name}_#{@version}"
        makedirs(@dest,:verbose=>false)
        @plugin_files.each do |fn|
          cp(fn, @dest,:verbose=>false)
          add_file(File.basename(fn))
        end
        
        @package_files.each do |fn|
          puts ". #{fn}" if verbose
          f = File.join(@dest, fn)
          fdir = File.dirname(f)
          unless File.exist?(fdir)
            mkdir_p(fdir,:verbose=>false)
            add_folder("#{fdir}/")
          end
          if File.directory?(fn)
            mkdir_p(f,:verbose=>false)
            add_folder("#{fn}/")
          else
            cp(fn, f, :verbose=>false)
            add_file(fn)
          end
        end
        
        generate_index_files()
      end
    end

    # Generate the index.html files
    def generate_index_files
      @folders.each do |folder, files|
        puts " + Creating #{@dest}/#{folder}/index.html" if @verbose
        File.open("#{@dest}/#{folder}/index.html", "w") do |index|
          title = "Rails Plug-in for #@name #@version"
          index.write("<html><head><title>#{title}</title></head>\n")
          index.write("<body>\n")
          index.write("<h2>#{title}</h2>\n")
          extra_links = create_extra_links()
          index.write("<p>#{extra_links}</p>\n") if extra_links          
          files.each { |fn|
            puts("  - Adding #{fn}") if @verbose
            index.write("&nbsp;&nbsp;<a href=\"#{fn}\">#{fn}</a><br/>\n")
          }
          index.write("<hr size=\"1\"/><p style=\"font-size: x-small\">Generated with RailsPluginPackageTask<p>")
          index.write("</body>\n")
          index.write("</html>\n")
        end
      end
    end
            
  private
    # Add a file to the folders hash
    def add_file(filename)
      dir = File.dirname(filename).gsub("#{@dest}",".")
      fn = File.basename(filename)
      folder = @folders[dir] || @folders[dir]=[]
      folder << fn
    end

    # Add a folder to the folders hash
    def add_folder(folder_name)
      dir = File.dirname(folder_name).gsub("#{@dest}",".").gsub("./","")
      fn = File.basename(folder_name) + "/"
      folder = @folders[dir] || @folders[dir]=[]
      folder << fn
    end
    
    # Create the anchor tag for extra links
    def create_extra_links
      return nil unless @extra_links
      x_links = ""
      if (@extra_links.class==Hash)
        @extra_links.each do |k,v|
          x_links << "<a href=\"#{v}\">#{k}</a>&nbsp;"
        end
      elsif (@extra_links.class==Array)
        @extra_links.each do |link|
          x_links << "<a href=\"#{link}\">#{link}</a>&nbsp;"
        end      
      else
        x_links = "<a href=\"#{@extra_links.to_s}\">#{@extra_links.to_s}</a>"
      end
      return x_links
    end
  end
end