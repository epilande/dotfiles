#!/bin/bash

# to maintain cask...
#   brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup

brew tap caskroom/cask

brew cask install alfred
brew cask install spectacle
brew cask install iterm2
brew cask install tower
brew cask install slack
brew cask install discord
brew cask install karabiner
brew cask install google-chrome
brew cask install firefox
brew cask install 1password
brew cask install flux
brew cask install bartender
brew cask install gyazo
brew cask install rescuetime
brew cask install sublime-text
brew cask install atom
brew cask install imageoptim
brew cask install vlc
brew cask install licecap
brew cask install caffeine
brew cask install screenhero
brew cask install skitch
brew cask install sketch
brew cask install sketch-toolbox
brew cask install vmware-fusion
brew cask install lumen

# https://github.com/sindresorhus/quick-look-plugins
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook suspicious-package

# Link cask apps to alfred
brew cask alfred link
