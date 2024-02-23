{ inputs, pkgs, username, ... }:{
	home-manager.users.stereomato.programs = {
		home-manager = {
			enable = true;
		};
		firefox = {
			enable =  true;
		};
		fish = {
			enable = true;
			shellInit = ''
				if status is-interactive
					# Commands to run in interactive sessions can go here
				end

				# Fish settings
				set -gx fish_greeting ""

				# Path tweaks
				# Not needed because of environment.localBinInPath
				#fish_add_path $HOME/.local/share/bin
				# Not needed on nixOS
				#fish_add_path /usr/sbin
				#fish_add_path /sbin
			'';
			
			shellAliases = {
				edit-fish-config = "nano $HOME/.config/fish/config.fish";
				disable-pstate = "sudo bash -c 'echo passive >  /sys/devices/system/cpu/intel_pstate/status'";
				enable-pstate = "sudo bash -c 'echo active >  /sys/devices/system/cpu/intel_pstate/status'";
				schedutil-tweak = "sudo bash -c 'echo 0 > /sys/devices/system/cpu/cpufreq/schedutil/rate_limit_us'";
				update-grub = "sudo grub-mkconfig -o /boot/grub/grub.cfg";
				memstats = "watch -n 0.5 cat /proc/meminfo";
				mic-latency-fix = "pw-cli s 49 Props '{ params = [ \"api.alsa.headroom\" 256 ] }'";
				mirror-phone = "scrcpy -b 10M --max-fps 60 -w -S";
				normalize-MONKE = "find . -name \*.ape -execdir loudgain -a -k -s e '{}' +";
				normalize-m4a = "find . -name \*.m4a -execdir loudgain -a -k -s e '{}' +";
				vscode-folder-fix = "gio mime inode/directory org.gnome.Nautilus.desktop";
				vmware-modules-fix = "sudo CPATH=/usr/src/kernels/$(uname -r)/include/linux vmware-modconfig --console --install-all";
				gpu-stats = "sudo intel_gpu_top";
				zswap_stats = "sudo (which zswap-stats)";
				dl-music-wav = "yt-dlp -x --audio-format wav --audio-quality 0";
				dl-music = "yt-dlp -x --audio-quality 0";
				mangohud-intel-workaround = "sudo chmod o+r /sys/class/powercap/intel-rapl\:0/energy_uj && echo 'Remember to run disable-mangohud-intel-workaround!'";
				disable-mangohud-intel-workaround = "sudo chmod o-r /sys/class/powercap/intel-rapl\:0/energy_uj";
				#wav2wvc = "find . -name \*.wav -execdir wavpack --allow-huge-tags -b256 -hh -x4 -c --import-id3 -m -v -w Encoder -w Settings {} -o ~/Music/WavPack/{}.temp \; -execdir wvgain ~/Music/WavPack/{}.temp \;";
				loudgain4wavs = "find . -name \*.wav -execdir loudgain -a -k --tagmode=e '{}' \;";
				connect2phone = "scrcpy --tcpip=192.168.1.50:39241 --power-off-on-close --turn-screen-off -b 10M --disable-screensaver --stay-awake";
				update-input-font-hash = "nix-prefetch-url 'https://input.djr.com/build/?fontSelection=whole&a=0&g=ss&i=serif&l=serif&zero=slash&asterisk=0&braces=straight&preset=default&line-height=1.2&accept=I+do&email=&.zip' --unpack --name input-fonts-1.2";

			};

			functions = {
				fish_prompt = {
					body = ''
						set -l last_pipestatus $pipestatus
						set -lx __fish_last_status $status
						
						if not set -q VIRTUAL_ENV_DISABLE_PROMPT
							set -g VIRTUAL_ENV_DISABLE_PROMPT true
						end

						# colorScheme has the value 'prefer-dark', had to escape the first ' to make this work. 	Dang.
						# However, this caused another issue, with VScode syntax highlight. So I just used sed (as seen above) to cut out the godforsaken quotations.
						set colorScheme (gsettings get org.gnome.desktop.interface color-scheme | sed "s/'//g")
						
						# $GNOME_SETUP_DISPLAY isn't set on TTYs, so this can be used to set the dark theme on ttys (and whatever other environment that might not be GNOME or doesn't set this variable)
						# That said, there's the "$prompt_use_dark_mode" variable, just in case to force this 
						if test "$colorScheme" = "prefer-dark" -o -z "$GNOME_SETUP_DISPLAY" -o -n "$prompt_use_dark_mode"
							switchColorschemes --prompt --skipSettingColors --darkMode
						else
							switchColorschemes --prompt --skipSettingColors
						end

						if test $USER = root
							set_color red
							printf '%s' $USER
							set_color normal
						else
							set_color $fish_color_user
							printf '%s' $USER
							set_color normal
						end
						
						printf ' at '

						set_color $fish_color_host
						echo -n (prompt_hostname)
						set_color normal
						printf ' in '

						set_color $fish_color_cwd
						printf '%s' (prompt_pwd)
						set_color normal
				
						if test $SHLVL -gt 1
							printf ' with'
							set_color $pearsche_fish_color_stack
							printf ' %u' $SHLVL
							set_color normal
							printf ' stacks'
							
						end

						if test $__fish_last_status -ne 0
							set_color $fish_color_error
							printf ' [%s]' $__fish_last_status
							set_color normal
						end
						
						if test -n "$VIRTUAL_ENV"
							printf "(%s) " (set_color blue)(basename $VIRTUAL_ENV)(set_color normal)
						end
						printf ' %% '
						set_color normal
					'';
				};
				fish_right_prompt = {
					body = ''
						printf '「%s 」' (date "+%H:%M:%S")
					'';
				};
			};
		};
		direnv = {
			enable = true;
			# Fish integration is always enabled
			#enableFishIntegration = true;
			enableBashIntegration = true;
			nix-direnv.enable = true;
		};
		# nix-index conflicts with this, so let's disable it.
		command-not-found.enable = false;
		micro = {
			enable = true;
			# See this page for configuration settings
			# https://github.com/zyedidia/micro/blob/master/runtime/help/options.md
			settings = {};
		};
		java = {
			enable = true;
			package = pkgs.jdk17;
		};
		gpg = {
			enable = true;
			# mutableKeys and mutableTrust are enabled by default
		};
		git = {
			enable = true;
			package = pkgs.gitFull;
			userName = "${username}";
			userEmail = "thepearsche@proton.me";
			delta = {
				enable = true;
			};
			lfs = {
				enable = true;
			};
			signing = {
				signByDefault = true;
				key = "AEC0A812DBBE4BC9";
			};

		};
		gh = {
			enable = true;
		};
		# Both the settings for btop, htop and mangohud have been removed as they are programs that
		# update their own settings at runtime thus making them unsuitable for this kind of configuration
		# Instead, their configuration folders are kept in this repo at ./to-symlink/ and
		# are symlinked by h-m
		btop = {
			enable = true;
		};
		htop = {
			enable = true;
		};
		
		
		yt-dlp = {
			enable = true;
			settings = {
				# No color output
				#--no-colors;
				# Set aria2 as downloader
				downloader = "aria2c";
				# aria2 arguments
				downloader-args = "aria2c:'-x 10'";
			};
		};
		man = {
			# TODO: https://github.com/nix-community/home-manager/issues/4624
			# package = pkgs.mandoc;
			generateCaches = true;
		};
		mangohud = {
			enable = true;
		};
		nix-index = {
			enable = true;
		};
		vscode = {
			enable = true;
			mutableExtensionsDir = false;
			# This shits up userSettings.json by making it read only.
			#enableUpdateCheck = false;
			extensions = [
				# Superseded by the direnv extension
				#pkgs.vscode-extensions.arrterian.nix-env-selector
				pkgs.vscode-extensions.donjayamanne.githistory
				pkgs.vscode-extensions.eamodio.gitlens
				pkgs.vscode-extensions.formulahendry.code-runner
				pkgs.vscode-extensions.github.github-vscode-theme
				pkgs.vscode-extensions.github.vscode-pull-request-github
				pkgs.vscode-extensions.jnoortheen.nix-ide
				pkgs.vscode-extensions.mkhl.direnv
				pkgs.vscode-extensions.ms-python.python
				pkgs.vscode-extensions.ms-toolsai.jupyter
				pkgs.vscode-extensions.ms-toolsai.jupyter-keymap
				pkgs.vscode-extensions.ms-toolsai.jupyter-renderers
				pkgs.vscode-extensions.ms-vscode-remote.remote-ssh
				pkgs.vscode-extensions.ms-vscode.cmake-tools
				pkgs.vscode-extensions.ms-vscode.cpptools
				pkgs.vscode-extensions.ms-vscode.hexeditor
				pkgs.vscode-extensions.ms-vscode.theme-tomorrowkit
				pkgs.vscode-extensions.piousdeer.adwaita-theme
				pkgs.vscode-extensions.pkief.material-product-icons
				pkgs.vscode-extensions.pkief.material-icon-theme
				pkgs.vscode-extensions.redhat.java
				pkgs.vscode-extensions.matklad.rust-analyzer
				# pkgs.vscode-extensions.skyapps.fish-vscode
				pkgs.vscode-extensions.twxs.cmake
				pkgs.vscode-extensions.vscjava.vscode-java-debug
				pkgs.vscode-extensions.vscjava.vscode-java-dependency
				pkgs.vscode-extensions.vscjava.vscode-java-test
				pkgs.vscode-extensions.vscjava.vscode-maven
				pkgs.vscode-extensions.vadimcn.vscode-lldb
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.kosz78.nim
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.cschlosser.doxdocgen
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.jeff-hykin.better-cpp-syntax
				# inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.jgclark.vscode-todo-highlight
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.josetr.cmake-language-support-vscode
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-dotnettools.vscode-dotnet-runtime
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-python.isort
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-python.vscode-pylance
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode-remote.remote-containers
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode-remote.remote-ssh-edit
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode-remote.remote-wsl
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode.cpptools-extension-pack
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode.cpptools-themes
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode.remote-explorer
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vsliveshare.vsliveshare
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.sainnhe.gruvbox-material
				#inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.VisualStudioExptTeam.intellicode-api-usage-examples
				#inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.VisualStudioExptTeam.vscodeintellicode
				#inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.VisualStudioExptTeam.vscodeintellicode-completions
				#inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.VisualStudioExptTeam.vscodeintellicode-insiders
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.vscjava.vscode-java-pack
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.gruntfuggly.todo-tree
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.bmalehorn.vscode-fish
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.dart-code.dart-code
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.dart-code.flutter
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.dart-code.flutter-local-device-exposer
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.elixir-tools.elixir-tools
				# This was confusing...
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.jakebecker.elixir-ls
			] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
					];
		};
		###
		mpv = {
			enable = true;
			config = {
				# Save position on quit
				save-position-on-quit = true;

				# Video
				vo = "gpu-next";
				hwdec = true;
				hwdec-codecs = "all";
				gpu-context = "auto";
				gpu-api = "vulkan";
				# GPU shader cache will be enabled by default on mpv 0.36, but I'm on 0.35 atm.
				gpu-shader-cache = true;
				gpu-shader-cache-folder = "~/.cache/mpv";
				# Likes to crash
				vf="scale_vaapi=mode=hq:force_original_aspect_ratio=decrease:format=p010";
				#blend-subtitles=true; # Enabling raises gpu usage considerably.
				deinterlace = "no"; # it's a default, but just in case
				#video-unscaled=true; # force vaapi scaling
				# gpu-next sets these to scalers that use too much power
				# and I already use vaapi scaling
				scale = "bilinear";
				#cscale="spline36";
				dscale = "bilinear";
				# The 3 following options are too much for when on battery, especially when using fractional scaling with the current upscale to 2x then downscale method.
				#linear-downscaling=true;
				# gpu-next enables these, too much power usage imo
				correct-downscaling = false;
				sigmoid-upscaling = false;
				# Interpolation is way too expensive on a intel iris xe graphics igpu
				tscale = "oversample";
				interpolation = true; # raises it a lil, least so far
				#video-sync = "display-resample"; # raises gpu usage a bit
				#video-sync-max-video-change = "5";
				opengl-pbo = true; # decreases gpu usage
				dither-depth = "auto";
				dither = "fruit"; # default
				deband = "no";
				deband-iterations = "2";
				deband-threshold = "24";
				deband-range = "8";
				deband-grain = "24";
				vulkan-async-compute = "yes"; # intel laptop igpus only have 1 queue
				vulkan-async-transfer = "yes"; # so this setting does nothing, but leave it on for the future
				vulkan-queue-count = "1"; # tfw only 1 queue

				# Colors
				gamut-mapping-mode = "saturation";
				libplacebo-opts-append="gamut_expansion=yes";
				target-colorspace-hint = "yes";
				# target-prim = "auto"; # default
				# target-trc = "auto"; # default
				tone-mapping = "hable";
				hdr-compute-peak = "auto"; # intel gpu bug, value should be no
				hdr-contrast-recovery = "0.5"; # new default when using gpu-hq

				# Audio
				#audio-swresample-o = "resampler=soxr,cutoff=0,matrix_encoding=dplii,cheby=1,precision=33,dither_method=improved_e_weighted";
				replaygain = "album";
				gapless-audio = true;
				audio-normalize-downmix = true;

				# Subtitles
				sub-auto = "fuzzy";
				sub-bold = true;
				sub-font = "monospace";

				# Screenshots
				screenshot-tag-colorspace = true;
				screenshot-high-bit-depth = true;
				screenshot-jpeg-quality = "100";
				screenshot-template = "%F-%P";

				# Inferface
				term-osd-bar = true;
				osd-fractions = "";
				image-display-duration = "5";
				osd-font-size = "30";
				osd-font = "system-uia";

				# Cache
				cache = true;
				cache-secs = "120";

				# yt-dlp
				#script-opts = "ytdl_hook-ytdl_path = yt-dlp";
				# Set maximum resolution to 1440p.
				# Good enough bitrate.
				ytdl-format = "bestvideo[height<=?1440]+bestaudio/best";
				ytdl-raw-options = "no-sponsorblock=,downloader=aria2c,downloader-args=aria2c:'-x 10'";
			};
			bindings = {
				RIGHT = "seek 5";
				LEFT = "seek -5";
				UP = "add volume 5";
				DOWN = "add volume -5";
				KP6 = "add speed 0.25";
				KP5 = "set speed 1";
				KP4 = "add speed -0.25";
			};
			scripts  = with pkgs.mpvScripts; [
				mpris
				# https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3145
				inhibit-gnome
				uosc
			];
		};
	};

	programs = {
		mtr.enable = true;
		fish = {
			enable = true; 
			useBabelfish = true;
		};
		steam = {
			enable = true;
			remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
			dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
		};
		adb.enable = true;
		usbtop.enable = true;
		atop = {
			enable = true;
			setuidWrapper.enable = true;
			atopService.enable = true;
			atopacctService.enable = true;
			# Nah, only supports Nvidia. #intelFTW
			#atopgpu.enable = true;
			netatop.enable = false;
		};
		# Gnome area
		# TODO: ask why these 2 and gnome-power-manager aren't in any of the 3 gnome toggles.
		gnome-terminal.enable = true;
		calls.enable = true;
		# nix-index conflicts with this, so let's disable it.
		command-not-found.enable = false;
	};
}