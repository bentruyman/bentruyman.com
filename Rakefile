require 'rake'

task :default => :build

desc 'Builds and compiles the site'
task :build do
  system 'jekyll'
end

desc 'Merges master branch into release branch and pushes the repository'
task :deploy do
  system 'git checkout release'
  system 'git merge master'
  system 'git push origin master'
  system 'git checkout master'
end

desc 'Continuously compiles the site and starts a simple web server to preview'
task :preview do
  system 'jekyll --server --auto'
end

desc 'Continuously compiles the site'
task :watch do
  system 'jekyll --auto'
end
