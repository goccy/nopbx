# coding: utf-8
require "thor"
require "nopbx/watcher"

module Nopbx
  class CLI < Thor

    desc "watch", "watch project.pbxproj"
    def watch(pbxproj=nil)
      unless pbxproj then
        puts "nopbx : must be assigned your project.pbxproj"
        return
      end
      Nopbx::Watcher.watch pbxproj
    end
    
  end

end
