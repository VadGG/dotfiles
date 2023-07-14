echo -e "\n\ninstalling to ~/.config"
echo "=============================="
if [ ! -d $HOME/.config ]; then
    echo "Creating ~/.config"
    mkdir -p $HOME/.config
fi
# configs=$( find -path "$DOTFILES/config.symlink" -maxdepth 1 )

shopt -s dotglob
DOTFILES=$(pwd)
echo "DOTFILES=$DOTFILES"

for config in $DOTFILES/config/*; do
    echo "config $config"
    target=$HOME/.config/$( basename $config )
    echo "target $target"
    if [ -e $target ]; then
        echo "~${target#$HOME} already exists... Skipping."
    else
        echo "Creating symlink for $config"
        ln -s $config $target
    fi
done

cd "$DOTFILES/homeconfig/"
for hconfig in *; do
    echo "config $hconfig"
    target=$HOME/$( basename $hconfig )
    echo "target $target"
    if [ -e $target ]; then
        echo "~${target#$HOME} already exists... Skipping."
    else
        echo "Creating symlink for $hconfig"
        ln $hconfig $target
    fi
done

