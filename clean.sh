echo -e "\n\nUninstalling current nvim setup"
echo "=============================="
set +x
rm -f $HOME/.config/nvim
rm -rf $HOME/.local/share/nvim
rm -rf $HOME/.local/state/nvim
rm -rf $HOME/.cache/nvim
