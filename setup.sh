CURRENT_FOLDER=$(pwd) && \
mkdir ~/.buren && \
cd ~/.buren && \
git clone git@github.com:buren/dot-bash.git && \
cat ~/.buren/dot-bash/setup/import/import_to_bash_profile >> ~/.bash_profile && \
source ~/.bash_profile && \
cd $CURRENT_FOLDER