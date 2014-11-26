############################################
# Add Repository
############################################
#tap  home/dupes               || true
#tap phinze/homebrew-cask       || true
brew tap caskroom/homebrew-versions || true  # add beta pkg
brew tap homebrew/binary            || true
brew tap jimbojsb/launchrocket      || true
brew tap homebrew/science           || true
#update || true


############################################
# Add Packages for Development
############################################
brew cask install 'xquartz'         # 依存されてるので先にInstall
brew install 'R'                    # required https://xquartz.macosforge.org/landing/
brew install 'autoconf'
brew install 'automake'
brew install 'bash'
brew install 'bdw-gc'
brew install 'cmake'                # be require from mysql
brew install 'colordiff'
brew install 'coreutils'
brew install 'cscope'
brew install 'ctags'
brew install 'curl'                 # ln -s ` --prefix curl`/bin/curl /usr/local/bin
brew install 'gdbm'
brew install 'gettext'
brew install 'gh'
brew install 'glib'
brew install 'gmp'
brew install 'gnu-sed' '--default-names'
brew install 'go'
brew install 'goaccess'
brew install 'graphicsmagick'
brew install 'htop-osx'
brew install 'hub'                  # wrapper for  git command
brew install 'icu4c'
brew install 'imagemagick' '--disable-openmp'
brew install 'jenkins'
brew install 'jpeg'
brew install 'jq'                   # JSONパーサー
brew install 'jsonpp'
brew install 'libevent'
brew install 'libffi'
brew install 'libpng'
brew install 'libtool'
brew install 'libxml2'  # for nokogiri
brew install 'libxslt'  # for nokogiri
brew install 'libyaml'
brew install 'lua'
brew install 'lv'
brew install 'lynx'
brew install 'macvim' '--with-lua --override-system-vim --custom-icons'
brew install 'multitail'
brew install 'mysql-connector-odbc' # for Tableau
brew install 'ngrep'
brew install 'nkf'
brew install 'nmap'                 # port scan util
brew install 'npm'
brew install 'oniguruma'
brew install 'pidof'
brew install 'pkg-config'
brew install 'pstree'
brew install 's3cmd'
brew install 'sqlite'
brew install 'sshfs'
brew install 'sshrc'                # sshした先で読み込む環境変数をローカルで定義できる
brew install 'tcpflow'              # いい感じでHTTPリクエストをモニタリング
brew install 'the_silver_searcher'
brew install 'tree'
brew install 'unixodbc'
brew install 'w3m'                  # CLI Web Browser
brew install 'watch'
brew install 'wget' '--enable-iri'
brew install 'xz'
brew install 'z'
brew install 'zsh' '--disable-etcdir'
#install 'bsdmake'
#install 'freetype'
#install 'fuse4x'
#install 'fuse4x-kext'
#install 'haskell-platform'     # Install until the end, very time-consuming
#install 'weechat' '--with-ruby --with-python --with-perl'
#install 'python3'
################
#  AWS
################
#aws-cfn-tools
#aws-elasticache
#aws-iam-tools
#yaws
#aws-mon
#aws-cloudsearch
#aws-elasticbeanstalk
#aws-sns-cli
#aws-as
#ec2-ami-tools
#ec2-api-tools
#rds-command-line-tools
#elb-tools
#s3cmd
#s3fs
################
#  Tmux
################
brew install 'tmux'
brew install 'reattach-to-user-namespace'
################
#  Bench Mark
################
brew install 'siege'
################
#  Ruby
################
brew install 'openssl'
brew install 'readline'
brew install 'ruby-build' --HEAD
brew install 'rbenv'
################
#  Git
################
brew install 'git'
brew install 'git-flow'
brew install 'tig'   # cli git browser
################
#  MySQL
################
# install 'mysql'
brew install 'mysql55'
################
#  FONT
################
# tap  'sanemat/font' || true
# install ricty || true
#         #cp -f /PATH/TO/RICTY/fonts/Ricty*.ttf ~/Library/Fonts/
#         #fc-cache -vf
################
#  PPSSPP  http://ppsspp.angelxwind.net/?page/downloads#osx
################
brew install 'sdl'
################
#  CSVTOOL
################
#install opam
# opam install csv

############################################
#  Cask          - 「 cask edit google-chrome」などで、オプション変更可能
############################################
#install brew-cask || true

brew cask install 'LightPaper'           # MarkdownEditor
brew cask install 'adobe-air'
brew cask install 'adobe-creative-cloud' # open  '/opt/homebrew-cask/Caskroom/adobe-creative-cloud/latest/Creative Cloud Installer.app'
brew cask install 'alfred'
brew cask install 'android-file-transfer'
brew cask install 'appcleaner'
brew cask install 'flux'
brew cask install 'bartender'
brew cask install 'bettertouchtool'
brew cask install 'camtasia'
brew cask install 'chefdk'               # Chef Development Kit
brew cask install 'microsoft-office'
brew cask install 'cooviewer'
brew cask install 'evernote'             # AppStore版だと、Spotlight検索に対応してないので、Download版で入れること
brew cask install 'flash'
brew cask install 'fluid'
brew cask install 'google-drive'
brew cask install 'google-japanese-ime'
brew cask install 'hockeyapp'            # アプリのβ版配付
#cask install 'intellij-idea'
brew cask install 'rubymine'
brew cask install 'iterm2'
brew cask install 'flashlight'
brew cask install 'keyremap4macbook'
brew cask install 'ksdiff'
brew cask install 'launchrocket'
brew cask install 'marked'
brew cask install 'omnigraffle'
brew cask install 'omnipresence'
brew cask install 'openemu-experimental'
brew cask install 'owncloud'
brew cask install 'perian'
brew cask install 'pixel-winch'
brew cask install 'quickcast'
brew cask install 'rcdefaultapp'
brew cask install 'silverlight'
#cask install 'skitch'
brew cask install 'skype'
brew cask install 'stay'                 # Window位置の記憶
brew cask install 'teamviewer'
brew cask install 'testflight'
brew cask install 'totalfinder'
brew cask install 'unity-web-player'
brew cask install 'vagrant'
brew cask install 'vagrant-manager'
brew cask install 'virtualbox'
brew cask install 'vlc'
brew cask install 'cloudytabs'
#cask install 'amazon-cloud-drive'
#cask install 'bathyscaphe'   # 2ch ブラウザ
#cask install 'clipmenu'
#cask install 'codekit'
#cask install 'dropbox'
#cask install 'forklift'
#cask install 'google-chrome'          # 手動で実体を/Applicationsフォルダに設置したほうがよい。でないと、1PasswordのExtentionが正常に動かない
#cask install 'google-chrome-canary'
#cask install 'google-web-designer'
#cask install 'gyazo'
#cask install 'keycue'
#cask install 'libreoffice'
#cask install 'mysqlworkbench'
#cask install 'parallels-9'
#cask install 'path-finder'
#cask install 'phpstorm'
#cask install 'postbox'
#cask install 'redis-desktop-manager'
#cask install 'reflector'
#cask install 'rstudio'
#cask install 'sequel-pro'
#cask install 'soundflower'
#cask install 'splashtop-streamer'
#cask install 'versions'             # Subversion Client
#cask install 'vmware-fusion'
#cask install 'x-quartz'

brew cask alfred link  # CaskroomをAlfredの検索パスに追加
################
# QuickLook Plugin
################
#cask install 'suspicious-package'
brew cask install 'betterzipql'
brew cask install 'qlcolorcode'
brew cask install 'qlvideo'
brew cask install 'qlmarkdown'
brew cask install 'qlprettypatch'
brew cask install 'qlstephen'       # view plain text files without a file extension
brew cask install 'quicklook-csv'
brew cask install 'quicklook-json'
brew cask install 'webp-quicklook'

############################################
# Remove outdated versions
###########################################e
brew linkapps
brew cleanup

############################################
#  Memo
############################################
# --config                     # Homebrewの設定一覧
# --prefix pkg名               # Install path
# cask search                  # lisgint cask Application
# leaves | sed 's/^/install /' # install済みpkgを追記
# cleanup
# doctor
# info                         # インストールしたpkgの設定方法確認
# link                         # パッケージを有効化
# options
# search                       # listing pkg
# tap                          # (ex. brew tap homebrew/dupes => GitHubにある外部のFormulaセットを追加することが可能になる
# unlink                       # パッケージを一時的に無効化
# cd ` --prefix`               # homebrewの保存先であるCellerディレクトリの場所に移動する
#
# 以下のApplicationは、現状Caskが無いので、手動でInstallする
# - Gyazo gif
# - GlyphDesigner
# - MS Office
# - ParticleDesigner
# - Lingr
# - Autoclick
#   SoundCleod
#- https://github.com/cookpad/iam-fox
#- https://github.com/cookpad/elasticfox-ec2tag
#- https://github.com/cookpad/r53-fox
## 個別に設定が必要なもの
# - Unclutter
# - Mi
