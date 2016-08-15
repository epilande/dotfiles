#!/bin/bash

# to maintain cask...
#   brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup

brew tap caskroom/cask

brew cask install alfred
brew cask install spectacle
brew cask install iterm2
brew cask install tower
brew cask install slack
brew cask install karabiner
brew cask install google-chrome
brew cask install firefox
brew cask install 1password
brew cask install flux
brew cask install gyazo
brew cask install rescuetime
brew cask install sublime-text
brew cask install atom
brew cask install imageotim
brew cask install vlc
brew cask install licecap

# https://github.com/sindresorhus/quick-look-plugins
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook suspicious-package

# Link cask apps to alfred
brew cask alfred link
