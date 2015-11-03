# Configure PostgresSQL
echo "smartvm" |sudo passwd --stdin postgres
#
#sudo systemctl start postgresql
echo "---> Starting PostgreSQL service"
if [ ! -a /var/opt/rh/rh-postgresql94/lib/pgsql/data ]
  then
  echo "Enabling SCL and postgresql94 in it"
 # Configuring postgres in it
 sudo scl enable rh-postgresql94 -- postgresql-setup --initdb
 sudo su -l postgres -c 'scl enable rh-postgresql94 -- initdb /var/lib/pgsql/data'
 #sudo scl enable rh-postgresql94 "/opt/rh/rh-postgresql94/root/usr/bin/postgresql-setup --initdb  /var/lib/pgsql/data"

 #sudo systemctl enable postgresql
 sudo systemctl enable rh-postgresql94-postgresql.service
 sudo systemctl start rh-postgresql94-postgresql.service
fi

#verify the status of postgresql 94
sudo systemctl status rh-postgresql94-postgresql.service

#sudo su postgres -c "psql -c \"CREATE ROLE root SUPERUSER LOGIN PASSWORD \\"smartvm\\"\""
#sudo su postgres -c "scl enable rh-postgresql94 -- psql -c \"CREATE ROLE root SUPERUSER LOGIN PASSWORD 'smartvm'\""
sudo su -l postgres -c 'scl enable rh-postgresql94 -- psql -c "CREATE ROLE root SUPERUSER LOGIN PASSWORD \"smartvm\""'
echo "---> User: $USER"
# install rbenv to manage ruby versions to be used

git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

source ~/.bash_profile

#configure ruby version
cd manageiq
echo "---> Continuing as $USER at $PWD"

#Configure rbenv with the preferred ruby version:
echo "---> Installing rbenv"
rbenv install 2.2.3
rbenv local 2.2.3
gem install bundler
gem install nokogiri -v '1.6.6.2'
scl enable rh-postgresql94 -- bundle install

#Copy the development keys to place
#Security risk, don't do this in production
echo "---> Installing development keys: DON'T DO THIS IN PRODUCTION"

cp /home/vagrant/manageiq/certs/v2_key.dev  /home/vagrant/manageiq/certs/v2_key


#Configure the database
echo "---> Configuring the PostgreSQL database"
if [ ! -a config/database.yml ]
  then
    cp config/database.pg.yml config/database.yml
    scl enable rh-postgresql94 -- bundle exec rake evm:db:reset
    scl enable rh-postgresql94 -- bundle exec rake db:seed
fi


# Start the service
echo "---> starting the service. You can access it as 127.0.0.1:3000 admin/smartvm"
scl enable rh-postgresql94 -- bundle exec rake evm:star
