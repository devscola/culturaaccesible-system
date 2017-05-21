#/bin/bash
bundle install --jobs 3
if [ ! -d "public/vendor" ]; then
  bundle exec rake prepare
fi
bundle exec rake
