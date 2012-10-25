#
# Author:: Andrew Crump (<andrew@kotirisoftware.com>)
# Copyright:: Copyright (c) 2012 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/cookbook/chefignore'
require 'chef/cookbook/cookbook_version_loader'

module TestKitchen
  module Project
    module CookbookCopy

      class Kitchenignore < Chef::Cookbook::Chefignore

        def initialize(ignore_file_or_repo)
          @ignore_file = find_kitchenignore_file(ignore_file_or_repo)
          @ignores = parse_ignore_file
          @cookbook_path = File.dirname(@ignore_file)
          @ignores += ['.git/*', 'test/*']
        end

        def find_kitchenignore_file(path)
          if File.basename(path) =~ /kitchenignore/
            path
          else
            File.join(path, 'kitchenignore')
          end
        end
      end

      class KitchenCookbookLoader < Chef::Cookbook::CookbookVersionLoader
        def chefignore
          @chefignore ||= Kitchenignore.new(@cookbook_path)
        end

        def copy_cookbook(dest)
          cookbook_settings.values.each do |files|
            files.each do |rel, full|
              dest_path = File.join dest, rel
              FileUtils.mkdir_p File.dirname(dest_path)
              FileUtils.cp full, dest_path
            end
          end
        end
      end

      def copied_cookbook_path(tmp_path)
        File.join(tmp_path, 'cookbook_under_test')
      end

      # This is a workaround to allow the top-level containing cookbook
      # to be copied to the kitchen tmp subdirectory.
      def copy_cookbook_under_test(root_path, tmp_path)
        cookbook_path = root_path.parent.parent
        loader = KitchenCookbookLoader.new cookbook_path
        loader.load_cookbooks
        loader.copy_cookbook(copied_cookbook_path tmp_path)
      end

      def clean_cookbook_under_test(tmp_path)
        FileUtils.rm_rf copied_cookbook_path(tmp_path)
      end
    end
  end
end
