rm -rf ~/.emacs.d
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install
cp doom/* ~/.doom.d
~/.emacs.d/bin/doom sync
