# coding: utf-8
require "thor"
require "nopbx/watcher"
require "nopbx/generator"

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

    desc "gen", "generate pbxproj directory from your project.pbxproj"
    def gen(pbxproj=nil)
      unless pbxproj then
        puts "nopbx : must be assigned your project.pbxproj"
        return
      end
      Nopbx::Generator.generate_nopbxfiles pbxproj
      puts "nopbx : generate [pbxproj] successfuly"
    end

    desc "restore", "restore project.pbxproj from pbxproj directory"
    def restore(pbxproj=nil)
      unless pbxproj then
        puts "nopbx : must be assigned your pbxproj directory"
        return
      end
      Nopbx::Generator.generate_pbxfile pbxproj
      puts "nopbx : generate [project.pbxproj] successfuly"
    end
  end

end
