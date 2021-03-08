# How to launch
## Prerequisite
 - ruby
 - bundler
## Initial setting
  - clone this repository
  - make `*.csv` file
  - set path to `*.csv` on `DATA_FILE` in `const.rb`
  ```
  DATA_FILE = 'path/to/*.csv'
  ```
## Install gems
  ```
  bundle install
  ```
### sinatra, webrick, and sinatra-contrib will be installed
 ## Launch main.rb
 ```
 bundle exec ruby main.rb
 ```
 ## Access to app
  - http://localhost:4567
