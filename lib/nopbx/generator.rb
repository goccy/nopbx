require "tempfile"
require "open3"
require "json"
require "yaml"
require "nopbx/parser"
require "fileutils"

module Nopbx
  class Generator
    class << self

      def plutil
        plutil = `which plutil`.to_s.chomp
        if plutil == '' then
          puts "must be installed plutil before executing command"
          return
        end
        plutil
      end

      def generate_pbxdirectory(pbxproj)
        ::File.dirname(::File.dirname pbxproj) + "/pbxproj"
      end
      
      def generate_nopbxfiles(pbxproj)
        tmpfile = Tempfile.new('')
        begin
          convert = "#{plutil} -convert json #{pbxproj} -o #{tmpfile.path}"
          exec_command convert
          json = load_json tmpfile.path
          generate_dir = generate_pbxdirectory pbxproj
          FileUtils.mkdir_p(generate_dir) unless Dir.exists? generate_dir
          objects = json['objects']
          object_group = Nopbx::Parser.parse(objects)
          json['objects'] = {}
          open("#{generate_dir}/project.yaml", "w") {|f| f.write YAML.dump(json) }
          object_group.each_key do |isa|
            sorted_objects = object_group[isa].sort do |a, b|
              a.keys.first <=> b.keys.first
            end
            yaml = YAML.dump(sorted_objects)
            open("#{generate_dir}/#{isa}.yaml", "w") {|f| f.write yaml }
          end
        ensure
          tmpfile.close
          tmpfile.unlink
        end
      end

      def generate_pbxfile(pbxproj)
        generate_dir = generate_pbxdirectory pbxproj
        return unless Dir.exists? generate_dir
        objects = {}
        Dir.glob("#{generate_dir}/*").reject { |yaml|
          /project.yaml$/.match(yaml)
        }.map { |yaml|
          /\.yaml$/.match(yaml) ? YAML.load_file(yaml) : []
        }.each { |array|
          array.each { |object|
            key = object.keys.first
            objects[key] = object[key]
          }
        }
        project = YAML.load_file "#{generate_dir}/project.yaml"
        project['objects'] = objects
        
        tmpfile = Tempfile.new('')
        begin
          tmpfile.print(project.to_json)
          convert = "#{plutil} -convert xml1 #{tmpfile.path} -o project.pbxproj"
          exec_command convert
        ensure
          tmpfile.close
          tmpfile.unlink
        end
      end

      def load_json(filepath)
        open(filepath) do |io|
	      JSON.load(io)
        end
      end

      def exec_command(command)
        stdin, stdout, stderr, wait_thr = *Open3.popen3(command)
        result = stdout
        stdin.close
        stdout.close
        stderr.close
        wait_thr.value
        result
      end
      
    end
  end
end
