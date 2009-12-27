
begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

ensure_in_path 'lib'
require 'auspost'

task :default => 'test:run'
task 'gem:release' => 'test:run'

Bones {
  name  'auspost'
  authors  'Cameron Barrie'
  email  'camwritescode@gmail.com'
  url  'www.camwritescode.com/auspost-gem'
  version  Auspost::VERSION
}

# EOF
