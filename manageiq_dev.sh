#install rubyversion
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
#git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

source ~/.bash_profile

#configure ruby version
cd manageiq
echo "continuing in manageiq/"

#Configure rbenv

rbenv install 2.2.3
rbenv local 2.2.3
gem install bundler
#gem install nokogiri -v '1.6.6.2'
#bundle install



#Configure the environment
echo "Configuring the database"
bin/setup                  # Installs dependencies, config, prepares database, etc
bundle exec rake evm:start # Starts the ManageIQ EVM Application in the background
bundle exec rails s        # Starts the application server

# Start the service
echo "starting the service. You can access it as 127.0.0.1:3000 admin/smartvm"
bundle exec rake evm:start
