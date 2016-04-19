# Enable EPEL & Install dnf in CentOS
sudo rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum -y install dnf

# install packages
sudo dnf -y install git-all                            # Git and components
sudo dnf -y install memcached                          # Memcached for the session store
sudo dnf -y install postgresql-devel postgresql-server # PostgreSQL Database server and to build 'pg' Gem
sudo dnf -y install bzip2 libffi-devel readline-devel  # For rbenv install 2.2.0 (might not be needed with other Ruby setups)
sudo dnf -y install libxml2-devel libxslt-devel patch  # For Nokogiri Gem
sudo dnf -y install gcc-c++                            # For event-machine Gem
sudo dnf -y install sqlite-devel                       # For sqlite3 Gem
sudo dnf -y install nodejs npm                         # For ExecJS Gem and bower
sudo dnf -y install openssl-devel                      # For rubygems
sudo dnf -y install cmake                              # For rugged Gem
dnf -y install bash-completion chrony deltarpm vim wget

# install bower package manager
sudo npm install -g bower

# Enable Memcached
systemctl enable memcached
systemctl start memcached

# install some requisites for rbenv
dnf install -y openssl-devel readline-devel

#needed for manageiq
#yum install -y graphviz-devel graphviz-ruby


# Installation of PostgreSQL
# Configure PostgresSQL
echo "smartvm" | passwd --stdin postgres
postgresql-setup initdb
grep -q '^local\s' /var/lib/pgsql/data/pg_hba.conf || echo "local all all trust" | sudo tee -a /var/lib/pgsql/data/pg_hba.conf
sed -i.bak 's/\(^local\s*\w*\s*\w*\s*\)\(peer$\)/\1trust/' /var/lib/pgsql/data/pg_hba.conf
systemctl enable postgresql
systemctl start postgresql
echo "smartvm" |  postgres -c "psql -c \"CREATE ROLE root SUPERUSER LOGIN PASSWORD 'smartvm'\""

