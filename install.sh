#!/bin/bash
set -euo pipefail

# --- COLORES ---
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
log()   { echo -e "${GREEN}[+]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[x]${NC} $1"; exit 1; }

# --- FUNCIONES ---
actualizar_sistema(){
	log "Actualizando sistema..."
	sudo pacman -Syu --noconfirm
}

instalar_base(){
	log "Instalando herramientas base..."
	sudo pacman -S --noconfirm --needed \
		base-devel git curl wget nvim zsh htop tmux
}

instalar_aur(){
	command -v yay &>/dev/null || {
		git clone https://aur.archlinux.org/yay.git /tmp/yay
		cd /tmp/yay && makepkg -si --noconfirm && cd -&& rm -rf /tmp/yay
	}
	yay -S --noconfirm google-chrome
}

configurar_zsh(){
	log "Configurando zsh..."
	chsh -s $(which zsh)
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

# --- MENU PRINCIPAL --
main(){
	echo "==========================="
	echo "   INSTALADOR ARCH LINUX   "
	echo "==========================="
	echo "1) Actualizar sistema"
	echo "2) Instalar paquetes base"
	echo "3) Instalar paquetes AUR"
	echo "4) Configurar zsh + Oh My Zsh"
	echo "5) Todo lo anterior"
	echo "0) Salir"
	echo ""
	read -rp "Elige una opcion: " opcion

	case $opcion in
		1) actualizar_sistema;;
		2) instalar_base ;;
		3) instalar_aur ;;
		4) configurar_zsh ;;
		5) actualizar_sistema; instalar_base; instalar_aur;;
		0) exit 0;;
		*) error "Opccion invalida"
	esac

	log "Instalacion Completada!!!..."
}

main
