cd ../simc
git clean -xdf
git pull
make -C engine -j 16 LTO=1 optimized
ln -s engine/simc simc
cd ../SimcScripts
bundle install
bundle exec ruby Run.rb
