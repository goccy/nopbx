require "listen"
require "nopbx/generator"

module Nopbx
  class Watcher
    class << self
      
      def watch(pbxproj)
        pbxproj_directory = Nopbx::Generator.generate_pbxdirectory pbxproj
        dirname  = ::File.dirname(pbxproj)
        start_listener pbxproj_directory, pbxproj
        start_listener dirname, pbxproj
        puts "Watch start"
        sleep
      end

      def start_listener(directory, pbxproj)
        listener = Listen.to(directory) do |modified, added, removed|
          modified.each do |f|
            puts "[MODIFY]" + f
            sync(f, pbxproj)
          end
          added.each do |f|
            puts "[ADD]" + f
            sync(f, pbxproj)
          end
          removed.each do |f|
            puts "[REMOVE]" + f
            sync(f, pbxproj)
          end
        end
        listener.start
      end

      def sync(filepath, pbxproj)
        filename = ::File.basename filepath
        if filename == 'project.pbxproj' then
          puts "sync project.pbxproj => pbxproj"
          Nopbx::Generator.generate_nopbxfiles pbxproj
        else
          puts "sync pbxproj => project.pbxproj"
          Nopbx::Generator.generate_pbxfile pbxproj
        end
      end
      
    end
  end
end
