#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
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

module TestKitchen
  module Project
    class Ruby < Base

      def install_command(runtime=nil, test_path=guest_test_root)
        cmd = "cd #{test_path}"
        cmd << " && rvm use #{runtime}" if runtime && ! runtime.empty?
        cmd << " && sudo gem install bundler"
        cmd << " && sudo #{install}"
      end

      def test_command(runtime=nil, test_path=guest_test_root)
        cmd = "cd #{test_path}"
        cmd << " && rvm use #{runtime}" if runtime && ! runtime.empty?
        cmd << " && #{script}"
      end
    end
  end
end
