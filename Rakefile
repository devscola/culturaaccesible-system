require 'rspec/core/rake_task'

task 'default' => :start

task :start do
  sh 'rerun --background -- rackup --port 4567 -o 0.0.0.0'
end

task 'test' do
  sh 'rspec'
end
