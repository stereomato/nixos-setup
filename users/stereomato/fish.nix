{ ... }:{
	home-manager.users.stereomato.programs.fish = {
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
}