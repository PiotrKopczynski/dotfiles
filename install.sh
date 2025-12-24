#!/bin/bash

# NOTES FOR ADDITIONAL INSTALLATIONS
# Download a nerdfont through nerdfonts.com/font-downloads (UbuntuMono Nerd Font or try Jetbrains)
# Install Bazecor from Dygma
# Install Karabiner-Elements
# Install Aerospace
# Install neovim from: https://github.com/neovim/neovim/releases/tag/stable
# Remember to install lsp-servers from npm
#Installed nvm (Node Package Manager for which is a version manager) WSL using: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash (verify installation nvm -v)
#Installed current stable release of Node.js (LTS release) using: nvm install --lts (You can install the current release using nvm install node) (verify installation: node --version; nvm --version)
#Mason possibly installs lsp's by itself as long as npm is available lsp-list: (bash-language-server, )
# Command to see manually installed packages:
# comm -23 <(apt-mark showmanual | sort) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort)
# Download docker manually
# Download mvn and java using sdkman
# Find some application launcher for Mac
# Autotiling for ubuntu

DOTFILES_DIR=$(pwd)
OS="$(uname)"
LINUX_PACKAGES_FILE="packages.txt"
CURL_INSTALLATIONS_FILE="curl_install_links.txt"
GITHUB_INSTALLATIONS_FILE="github_repos.txt"

install_macos() {
	echo "🍎 Detected macOS. Using Homebrew..."

	# Necessary to compile software on Mac. Similar to build-essentials on Debian
	if ! xcode-select -p &>/dev/null; then
	  xcode-select --install
	fi

	#Install Homebrew if not found
	if ! command -v brew &> /dev/null; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi

	# Install everything in the Brewfile
	brew bundle --file="$DOTFILES_DIR/Brewfile"
}

install_ubuntu() {
	echo "🐧 Detected Linux (Ubuntu). Using APT..."

	sudo apt update
	#Install packages from packages.txt
	grep -v '^#' "$DOTFILES_DIR/$LINUX_PACKAGES_FILE" | xargs sudo apt install -y

	#installed using go
	#sesh
	go install github.com/joshmedeski/sesh/v2@latest

	# Special cases
	# eza
	sudo apt install -y gpg
	sudo mkdir -p /etc/apt/keyrings
	wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
	echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
	sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
	sudo apt update
	sudo apt install -y eza
}

install_from_curl() {
	echo "🌐 Installing via Curl..."
	while IFS='|' read -r name url target os; do
		# Skip comments and empty lines
		[[ "$name" =~ ^#.*$ || -z "$name" ]] && continue

		local current_os=$(uname | tr '[:upper:]' '[:lower:]') # 'linux' or 'darwin'

		if [[ "$current_os" != "all" ]]; then
			if [[ "$os" == "linux" && "$current_os" != "linux" ]]; then continue; fi
			if [[ "$os" == "mac" && "$current_os" != "darwin" ]]; then continue; fi
		fi

		if ! command -v "$name" &> /dev/null; then
			echo "Installing $name..."
			vurl -sSfL "$url" | "$target"
		else
			echo "$name is already installed"
		fi 
	done < "$DOTFILES_DIR/$CURL_INSTALLATIONS_FILE"
}

install_from_github() {
	echo "🐙 Cloning GitHub Repos..."
	while IFS='|' read -r path url; do 
		#Skip comments and empty lines
		[[ "$path" =~ ^#.*$ || -z "$path" ]] && continue

		full_path="$HOME/$path"

		if [ ! -d "$full_path" ]; then
			echo "Cloning $url to $full_path..."
			git clone "$url" "$full_path"
		else
			echo "$path already exists, pulling updates..."
			git -C "$full_path" pull
		fi
	done < "$DOTFILES_DIR/$GITHUB_INSTALLATIONS_FILE"
}


# --- Main Execution ---
if [ "$OS" == "Darwin" ]; then
	install_macos
elif [ "$OS" == "Linux" ]; then
	install_ubuntu
else
	echo "Unsupported OS"
	exit 1
fi

install_from_curl 
install_from_github 

# Stow
echo "🔗 Symlinking dotfiles..."
for dir in */; do
	stow "${dir%/}"
done

echo "✅ Setup complete! Restart your shell."
