# Chezmoi Dotfiles

```
cd $HOME
mkdir bin
cd bin
curl -L https://raw.githubusercontent.com/joemiller/dotfiles/master/install-chezmoi.sh | bash
echo "export PATH=\$PATH:$PWD" >> ~/.bashrc
source ~/.bashrc
```

And install repo:

```
chezmoi init https://github.com/alkuzad/configs/
chezmoi apply
```
