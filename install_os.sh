#install new repos and some utils
yum -y install epel-release bash-completion chrony deltarpm vim wget

#install software collections
pushd /etc/yum.repos.d/
wget http://copr.fedoraproject.org/coprs/abellott/manageiq-scl/repo/epel-7/abellott-manageiq-scl-epel-7.repo
popd
rpm -Uvh https://www.softwarecollections.org/repos/rhscl/rh-postgresql94/epel-7-x86_64/noarch/rhscl-rh-postgresql94-epel-7-x86_64.noarch.rpm


# install packages
yum -y install git-all memchached                           # Git and components, Memcached for the session store

#yum -y install postgresql-devel postgresql-server # PostgreSQL Database server and to build 'pg' Gem
yum -y install openslp-devel rh-postgresql94-postgresql rh-postgresql94-postgresql-devel rh-postgresql94-postgresql-server scl-utils scl-utils-build
yum -y install libxml2-devel libxslt-devel patch gcc-c++ # For Nokogiri Gem, and for event-machine Gem


# Enable Memcached
systemctl enable memcached
systemctl start memcached

# install some requisites for rbenv and some others fro the kickstart file
yum install -y openssl-devel readline-devel gbdm-devel libffi-devel libyaml-devel ncurses-devel zlib-devel lshw nfs-utils nodejs OpenIPMI

#needed for manageiq
yum install -y graphviz-devel graphviz-ruby
