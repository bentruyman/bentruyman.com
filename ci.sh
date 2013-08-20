bundle install
bundle exec rake
rm -rf /var/www/bentruyman.com/*
cp -R ./public/* /var/www/bentruyman.com
