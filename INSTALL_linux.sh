#/bin/bash

echo ''
echo '[*] Welcome to the installer for edit.tosdr.org!'
echo ''
echo '  ###############'
echo '  ###############'
echo '  ###########          I have read and agreed to the terms'
echo '  ###########          is the biggest lie on the web.'
echo '  #######'
echo '  #######              We aim to fix that.'

sleep 1;
echo ''
echo '[*] Installing Rbenv'

if [ -d ~/.rbenv/plugins/ruby-build ]; then
  echo 'Rbenv already exists.'
else
  echo 'Rbenv missing; installing...'  
  export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash
fi
echo 'Installing Ruby 2.3.5, it might take a while...'
read -n 1
rbenv install 2.3.5


echo '[*] Installing yarn'

if hash yarn 2>/dev/null; then
  echo 'You have yarn!'
else
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
 sudo apt-get update && sudo apt-get install yarn
fi

echo '[*] Installing postgres'

if hash psql 2>/dev/null; then
  echo 'You have postgres!'
else
  echo '[*] Installing postgres'
  sudo apt-get install -y postgresql postgresql-contrib libpq-dev build-essential
  # TODO: find a way to setup postgres for the user
  #echo `whoami` > /tmp/caller
  #sudo su - postgres
  #psql --command "CREATE ROLE `cat /tmp/caller` LOGIN createdb;"
  #exit
  #rm -f /tmp/caller
fi

echo '[*] Setting local ruby version to 2.3.5'
rbenv local 2.3.5
echo '[*] Installing gems'
bundle install
echo '[*] Compiling JS'
yarn install
echo '[*] Setting up the database'
rails db:create db:migrate

echo '[*] You are ready to go! Run "rails server" to start the server'
