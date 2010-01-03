begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

ensure_in_path 'lib'
require 'auspost'

task :default => 'spec'
task 'gem:release' => 'test:run'
Bones {
  name     'auspost'
  authors  'Cameron Barrie'
  email    'camwritescode@gmail.com'
  depend_on 'nokogiri'
  url      'http://wiki.github.com/whalec/auspost'
  version  Auspost::VERSION
}

# EOF
