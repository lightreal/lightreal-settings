cscope_maps.vim : ~/.vim/plugin/
vimrc : ~/.vimrc
ssh_config : ~/.ssh/config
commit_msg : $(git_project)/.git/hook/
git diff so fancy
- npm install -g diff-so-fancy
- git config --global pager.diff "diff-so-fancy | less --tabs=4 -RFX"
- git config --global pager.show "diff-so-fancy | less --tabs=4 -RFX"
