module Nopbx
  class Parser
    class << self
      
      def parse(objects)
        object_group = {}
        objects.sort.map do |key, value|
          isa = value['isa']
          object_group[isa] ||= []
          hash = {}
          hash[key] = value
          object_group[isa] << hash
        end
        object_group
      end
      
    end
  end
end
