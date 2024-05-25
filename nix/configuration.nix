# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, systemd, ... }:

let 
	#ultraleap-hand-tracking = import "/home/hjgarrett/NixOS\ Packages/ultraleap/ultraleap.nix" { inherit pkgs; };
	unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };

	# Custom packages
	sugar-candy-sddm = pkgs.stdenv.mkDerivation {
		pname = "sugar-candy";
		version = "1.6";
		src = pkgs.fetchFromGitHub {
			owner = "Khyonie";
			repo = "sddm-sugar-candy";
			rev = "e5f7fd4";
			sha256 = "sha256-slyfGfBI2og/a59TkQpevk6laMWNo+2ISdAbSrxtaL4=";
		};

		buildInputs = [ pkgs.git ];

		installPhase = ''
			mkdir -p $out/share/sddm/themes/sugar-candy-sddm
			cp -r $src/* $out/share/sddm/themes/sugar-candy-sddm/
		'';
	};
in
{
	imports = [ ./hardware-configuration.nix ];

	# Boot
	boot = {
		kernelPackages = pkgs.linuxPackages_latest;
		supportedFilesystems = [ "ntfs" ];
		kernelParams = [ "amd_iommu=on" "pcie_aspm=off" "quiet" "splash" "rd.udev.log_level=2" ];
		kernelModules = [ "kvm-amd" ];
		consoleLogLevel = 0;
		initrd = {
			kernelModules = [ "amdgpu" ];
			availableKernelModules = [ "amdgpu" "vfio-pci" ];
			verbose = false;
		};
		loader = {
			systemd-boot.enable = true;
			efi.canTouchEfiVariables = true;
		};
	};

	# Virtualisation
	virtualisation.libvirtd = {
		enable = true;
		qemu.ovmf.enable = true;
		qemu.swtpm.enable = true;
		onBoot = "ignore";
		onShutdown = "shutdown";
	};
	
	virtualisation.docker.enable = true;

	#boot.initrd.preDeviceCommands = ''
	#	echo "vfio-pci" > /sys/bus/pci/devices/0000:1a:00.0/driver_override
	#	modprobe -i vfio-pci
	#'';

	# System configuration
	networking.hostName = "constellations"; # Define your hostname.
	time.timeZone = "America/Denver";
	networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
	networking.firewall.enable = false;
	hardware.bluetooth.enable = true;
	hardware.bluetooth.settings = {
		General = {
			Enable = "Source,Sink,Media,Socket";
		};
	};
	nixpkgs.config.allowUnfree = true;

	# Audio
	hardware.pulseaudio.package = pkgs.pulseaudioFull;

	# OpenGL
	hardware.opengl.extraPackages = with pkgs; [
		amdvlk
		libva
		intel-media-driver
	];

	# X11 configuration
	#-------------------------------------------------------------------------------- 
	services.xserver = {
		enable = true;

		xkb = {
			variant = "dvorak";
			layout = "us";
		};

		
	};

	services.displayManager.sddm = {
		enable = true;
		wayland.enable = true;
		theme = "sugar-candy-sddm";
	};

	console.useXkbConfig = true;

	# Authentication
	#-------------------------------------------------------------------------------- 
	security = {
		sudo.enable = false;
		doas.enable = true;
		doas.extraRules = [{ 
				groups = [ "wheel" ]; 
			} {
				users = [ "hjgarrett" ];
				persist = true;
			}
		];
	};

	programs = {
		hyprland = {
			enable = true;
			xwayland.enable = true;
		};
		steam = {
			enable = true;
		};
		fish.enable = true;
		noisetorch.enable = true;
		streamdeck-ui.enable = true;

		nix-ld.enable = true;
		nix-ld.libraries = with pkgs; [
			gtk4
			pkg-config
		];

		neovim.enable = true;

		nautilus-open-any-terminal = {
			enable = true;
			terminal = "kitty";
		};
	};

	# System service settings
	#-------------------------------------------------------------------------------- 
	services.printing.enable = true;
	services = {
		pipewire = {
			enable = true;
			audio.enable = true;
			pulse.enable = true;
			jack.enable = true;
		};
		gvfs.enable = true;
		gnome.sushi.enable = true;
	};

	# Fonts
	#-------------------------------------------------------------------------------- 
	fonts.packages = with pkgs; [
		(nerdfonts.override { fonts = [ "Hermit" ]; })
	];

	# Globally installed packages
	#-------------------------------------------------------------------------------- 
	environment.systemPackages = with pkgs; [
		# Global environment
		vim 
		wget
		git
		kitty
		dhcpcd
		curlFull

		# Wayland environment
		dunst
		wofi
		hyprpaper
		libsForQt5.qt5.qtgraphicaleffects
		sugar-candy-sddm
		gsettings-desktop-schemas
		xdg-desktop-portal
		xdg-desktop-portal-hyprland
		xdg-desktop-portal-gtk
		bottles-unwrapped
		national-park-typeface
		SDL2
		protontricks

		# Filesystem support
		ntfs3g
		lvm2
		exfat
		ldmtool
	];

	# User configuration & per-user packages
	#-------------------------------------------------------------------------------- 
	users.groups.nixconfigure = { };
	users.defaultUserShell = pkgs.fish;
	users.users.hjgarrett = {
		isNormalUser = true;
		extraGroups = [ "wheel" "libvirtd" "docker" "nixconfigure" ];
		packages = with pkgs; [
			neofetch
			vivaldi
			discord
			vesktop
			grim
			gtk3
			gtk4
			slurp
			wl-clipboard
			gnome.file-roller
			gnome.gnome-sound-recorder
			gnome.nautilus
			glib
			steam
			obsidian
			spotify
			gimp
			vlc
			dxvk_2
			vkd3d-proton
			wineWowPackages.waylandFull
			r2modman
			virt-manager
			looking-glass-client
			easyeffects
			urn-timer
			prismlauncher
			websocat
			dolphin-emu

			rustc
			rustup
			pkg-config
			dpkg
			cargo
			jdk
			jdk17
			jdk8
			jdt-language-server
			/nix/store/zwj7pkqr52w9yd00lpr7lbm8vxjjg94n-Wisteria-2.1.7
			eclipses.eclipse-java

			pavucontrol
			qpwgraph

			(wrapOBS {
				plugins = with obs-studio-plugins; [
					obs-webkitgtk
					obs-vkcapture
					wlrobs
					obs-vaapi
					obs-composite-blur
					obs-backgroundremoval
					input-overlay
					obs-tuna
					waveform
				];	
			})

			libsForQt5.kdenlive
			themechanger

		];
	};

	#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= 
	#                   End configuration. Do not change these.                     #
	#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= 

	system.copySystemConfiguration = true;

	system.stateVersion = "23.11"; # Did you read the comment?
}
