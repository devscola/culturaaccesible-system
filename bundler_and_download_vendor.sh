#/bin/bash
bundle install --jobs 3
if [ ! -f "public/vendor/polymer/polymer.html" ] \
   || [ ! -f "public/vendor/polymer/polymer-micro.html" ] \
   || [ ! -f "public/vendor/polymer/polymer-mini.html" ] \
   || [ ! -f "public/vendor/polymer/webcomponents-lite.min.js" ] \
   || [ ! -f "public/vendor/classjs/class.min.js" ]  ; then
  bundle exec rake prepare
fi
bundle exec rake
