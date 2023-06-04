{ username, pkgs, ... }:
{
	programs = {
		home-manager = {
			enable = true;
		};
		firefox = {
			enable =  true;
		};
		direnv = {
			enable = true;
			# Fish integration is always enabled
			#enableFishIntegration = true;
			enableBashIntegration = true;
			nix-direnv.enable = true;
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
						
						# $GNOME_SETUP_DISPLAY isn't set on ttys, so this can be used to set the dark theme on ttys (and whatever other environment that might not be GNOME or doesn't set this variable)
						# That said, there's the "$prompt_use_dark_mode" variable, just in case to force this 
						if test "$colorScheme" = "prefer-dark" -o -z "$GNOME_SETUP_DISPLAY" -o -n "$prompt_use_dark_mode"
							switchColorschemes --prompt adwaita-dark
						else
							switchColorschemes --prompt adwaita-light
						end
						
						if test $USER = root
							set_color red
							printf '%s' $USER
							set_color normal
						else
							set_color yellow
							printf '%s' $USER
							set_color normal
						end
						
						printf ' at '

						set_color magenta
						echo -n (prompt_hostname)
						set_color normal
						printf ' in '

						set_color $fish_color_cwd
						printf '%s' (prompt_pwd)
						set_color normal


						if test $__fish_last_status -ne 0
							set_color red
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

			};
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
				key = "F233FBE900BDC393";
			};

		};
		gh = {
			enable = true;
		};
		btop = {
			enable = true;
			settings = {
				#? Config file for btop v. 1.2.9

				#* Name of a btop++/bpytop/bashtop formatted ".theme" file, "Default" and "TTY" for builtin themes.
				#* Themes should be placed in "../share/btop/themes" relative to binary or "$HOME/.config/btop/themes"
				color_theme = "Default";

				#* If the theme set background should be shown, set to false if you want terminal background transparency.
				theme_background = true;

				#* Sets if 24-bit truecolor should be used, will convert 24-bit colors to 256 color (6x6x6 color cube) if false.
				truecolor = true;

				#* Set to true to force tty mode regardless if a real tty has been detected or not.
				#* Will force 16-color mode and TTY theme, set all graph symbols to "tty" and swap out other non tty friendly symbols.
				force_tty = false;

				#* Define presets for the layout of the boxes. Preset 0 is always all boxes shown with default settings. Max 9 presets.
				#* Format: "box_name:P:G,box_name:P:G" P=(0 or 1) for alternate positions, G=graph symbol to use for box.
				#* Use withespace " " as separator between different presets.
				#* Example: "cpu:0:default,mem:0:tty,proc:1:default cpu:0:braille,proc:0:tty"
				presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";

				#* Set to true to enable "h,j,k,l,g,G" keys for directional control in lists.
				#* Conflicting keys for h:"help" and k:"kill" is accessible while holding shift.
				vim_keys = false;

				#* Rounded corners on boxes, is ignored if TTY mode is ON.
				rounded_corners = true;

				#* Default symbols to use for graph creation, "braille", "block" or "tty".
				#* "braille" offers the highest resolution but might not be included in all fonts.
				#* "block" has half the resolution of braille but uses more common characters.
				#* "tty" uses only 3 different symbols but will work with most fonts and should work in a real TTY.
				#* Note that "tty" only has half the horizontal resolution of the other two, so will show a shorter historical view.
				graph_symbol = "block";

				# Graph symbol to use for graphs in cpu box, "default", "braille", "block" or "tty".
				graph_symbol_cpu = "default";

				# Graph symbol to use for graphs in cpu box, "default", "braille", "block" or "tty".
				graph_symbol_mem = "default";

				# Graph symbol to use for graphs in cpu box, "default", "braille", "block" or "tty".
				graph_symbol_net = "default";

				# Graph symbol to use for graphs in cpu box, "default", "braille", "block" or "tty".
				graph_symbol_proc = "default";

				#* Manually set which boxes to show. Available values are "cpu mem net proc", separate values with whitespace.
				shown_boxes = "cpu mem net proc";

				#* Update time in milliseconds, recommended 2000 ms or above for better sample times for graphs.
				update_ms = 1000;

				#* Processes sorting, "pid" "program" "arguments" "threads" "user" "memory" "cpu lazy" "cpu direct",
				#* "cpu lazy" sorts top process over time (easier to follow), "cpu direct" updates top process directly.
				proc_sorting = "cpu lazy";

				#* Reverse sorting order, true or false.
				proc_reversed = false;

				#* Show processes as a tree.
				proc_tree = false;

				#* Use the cpu graph colors in the process list.
				proc_colors = true;

				#* Use a darkening gradient in the process list.
				proc_gradient = true;

				#* If process cpu usage should be of the core it's running on or usage of the total available cpu power.
				proc_per_core = false;

				#* Show process memory as bytes instead of percent.
				proc_mem_bytes = true;

				#* Show cpu graph for each process.
				proc_cpu_graphs = true;

				#* Use /proc/[pid]/smaps for memory information in the process info box (very slow but more accurate)
				proc_info_smaps = false;

				#* Show proc box on left side of screen instead of right.
				proc_left = false;

				#* (Linux) Filter processes tied to the Linux kernel(similar behavior to htop).
				proc_filter_kernel = false;

				#* Sets the CPU stat shown in upper half of the CPU graph, "total" is always available.
				#* Select from a list of detected attributes from the options menu.
				cpu_graph_upper = "total";

				#* Sets the CPU stat shown in lower half of the CPU graph, "total" is always available.
				#* Select from a list of detected attributes from the options menu.
				cpu_graph_lower = "total";

				#* Toggles if the lower CPU graph should be inverted.
				cpu_invert_lower = true;

				#* Set to true to completely disable the lower CPU graph.
				cpu_single_graph = false;

				#* Show cpu box at bottom of screen instead of top.
				cpu_bottom = false;

				#* Shows the system uptime in the CPU box.
				show_uptime = true;

				#* Show cpu temperature.
				check_temp = true;

				#* Which sensor to use for cpu temperature, use options menu to select from list of available sensors.
				cpu_sensor = "Auto";

				#* Show temperatures for cpu cores also if check_temp is true and sensors has been found.
				show_coretemp = true;

				#* Set a custom mapping between core and coretemp, can be needed on certain cpus to get correct temperature for correct core.
				#* Use lm-sensors or similar to see which cores are reporting temperatures on your machine.
				#* Format "x:y" x=core with wrong temp, y=core with correct temp, use space as separator between multiple entries.
				#* Example: "4:0 5:1 6:3"
				cpu_core_map = "";

				#* Which temperature scale to use, available values: "celsius", "fahrenheit", "kelvin" and "rankine".
				temp_scale = "celsius";

				#* Use base 10 for bits/bytes sizes, KB = 1000 instead of KiB = 1024.
				base_10_sizes = false;

				#* Show CPU frequency.
				show_cpu_freq = true;

				#* Draw a clock at top of screen, formatting according to strftime, empty string to disable.
				#* Special formatting: /host = hostname | /user = username | /uptime = system uptime
				clock_format = "%X";

				#* Update main ui in background when menus are showing, set this to false if the menus is flickering too much for comfort.
				background_update = true;

				#* Custom cpu model name, empty string to disable.
				custom_cpu_name = "";

				#* Optional filter for shown disks, should be full path of a mountpoint, separate multiple values with whitespace " ".
				#* Begin line with "exclude=" to change to exclude filter, otherwise defaults to "most include" filter. Example: disks_filter="exclude=/boot /home/user".
				disks_filter = "";

				#* Show graphs instead of meters for memory values.
				mem_graphs = true;

				#* Show mem box below net box instead of above.
				mem_below_net = false;

				#* Count ZFS ARC in cached and available memory.
				zfs_arc_cached = true;

				#* If swap memory should be shown in memory box.
				show_swap = true;

				#* Show swap as a disk, ignores show_swap value above, inserts itself after first disk.
				swap_disk = true;

				#* If mem box should be split to also show disks info.
				show_disks = true;

				#* Filter out non physical disks. Set this to false to include network disks, RAM disks and similar.
				only_physical = true;

				#* Read disks list from /etc/fstab. This also disables only_physical.
				use_fstab = true;

				#* Setting this to true will hide all datasets, and only show ZFS pools. (IO stats will be calculated per-pool)
				zfs_hide_datasets = false;

				#* Set to true to show available disk space for privileged users.
				disk_free_priv = false;

				#* Toggles if io activity % (disk busy time) should be shown in regular disk usage view.
				show_io_stat = true;

				#* Toggles io mode for disks, showing big graphs for disk read/write speeds.
				io_mode = false;

				#* Set to true to show combined read/write io graphs in io mode.
				io_graph_combined = false;

				#* Set the top speed for the io graphs in MiB/s (100 by default), use format "mountpoint:speed" separate disks with whitespace " ".
				#* Example: "/mnt/media:100 /:20 /boot:1".
				io_graph_speeds = "";

				#* Set fixed values for network graphs in Mebibits. Is only used if net_auto is also set to false.
				net_download = 100;

				net_upload = 100;

				#* Use network graphs auto rescaling mode, ignores any values set above and rescales down to 10 Kibibytes at the lowest.
				net_auto = true;

				#* Sync the auto scaling for download and upload to whichever currently has the highest scale.
				net_sync = true;

				#* Starts with the Network Interface specified here.
				net_iface = "";

				#* Show battery stats in top right if battery is present.
				show_battery = true;

				#* Which battery to use if multiple are present. "Auto" for auto detection.
				selected_battery = "Auto";

				#* Set loglevel for "~/.config/btop/btop.log" levels are: "ERROR" "WARNING" "INFO" "DEBUG".
				#* The level set includes all lower levels, i.e. "DEBUG" will show all logging info.
				log_level = "WARNING";
			};
		};
		htop = {
			# TODO: update this
			enable = true;
			settings = {
				# Beware! This file is rewritten by htop when settings are changed in the interface.
				# The parser is also very primitive, and not human-friendly.
				htop_version = "3.2.1";
				config_reader_min_version = 3;
				fields = "0 48 17 18 38 39 40 2 46 47 49 1";
				hide_kernel_threads = 0;
				hide_userland_threads = 0; 
				shadow_other_users = 0;
				show_thread_names = 1;
				show_program_path = 0;
				highlight_base_name = 1;
				highlight_deleted_exe = 1;
				highlight_megabytes = 1;
				highlight_threads = 1;
				highlight_changes = 1;
				highlight_changes_delay_secs = 5;
				find_comm_in_cmdline = 1;
				strip_exe_from_cmdline = 1;
				show_merged_command = 1;
				header_margin = 1;
				screen_tabs = 0;
				detailed_cpu_time = 1;
				cpu_count_from_one = 1;
				show_cpu_usage = 1;
				show_cpu_frequency = 1;
				show_cpu_temperature = 1;
				degree_fahrenheit = 0;
				update_process_names = 1;
				account_guest_in_cpu_meter = 1;
				color_scheme = 0;
				enable_mouse = 1;
				delay = 10;
				hide_function_bar = 0;
				header_layout = "two_50_50";
				column_meters_0 = "Battery AllCPUs Memory HugePages Swap Zram DiskIO NetworkIO";
				column_meter_modes_0 = "1 1 1 1 1 1 2 2";
				column_meters_1 = "DateTime Clock System Hostname Systemd SELinux Tasks LoadAverage Uptime PressureStallCPUSome PressureStallIOFull PressureStallMemoryFull";
				column_meter_modes_1 = "2 2 2 2 2 2 2 2 2 2 2 2";
				tree_view = 0;
				sort_key = 46;
				tree_sort_key = 0;
				sort_direction = "-1";
				tree_sort_direction = 1;
				tree_view_always_by_pid = 0;
				all_branches_collapsed = 0;
				"screen:Main" = "PID USER PRIORITY NICE M_VIRT M_RESIDENT M_SHARE STATE PERCENT_CPU PERCENT_MEM TIME Command";
			};
		};
		vscode = {
			enable = true;
			# This shits up userSettings.json by making it read only.
			#enableUpdateCheck = false;
			extensions = [
				pkgs.vscode-extensions.arrterian.nix-env-selector
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
				pkgs.vscode-extensions.skyapps.fish-vscode
				pkgs.vscode-extensions.twxs.cmake
				pkgs.vscode-extensions.vscjava.vscode-java-debug
				pkgs.vscode-extensions.vscjava.vscode-java-dependency
				pkgs.vscode-extensions.vscjava.vscode-java-test
				pkgs.vscode-extensions.vscjava.vscode-maven
				pkgs.vscode-extensions.vadimcn.vscode-lldb
			] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
						{
    					name = "doxdocgen";
    					publisher = "cschlosser";
    					version = "1.4.0";
    					sha256 = "1d95znf2vsdzv9jqiigh9zm62dp4m9jz3qcfaxn0n0pvalbiyw92";
  					}
						#{
    				#	name = "gtk-dark-titlebar";
    				#	publisher = "fkrull";
    				#	version = "1.3.0";
    				#	sha256 = "15waf36j162i247z8c0dzd1807iww9gmwrnsc7w20i00x66k5gld";
  					#}
						#{
						#	name = "gtk-dark-titlebar";
						#	publisher = "fkrull";
						#	version = "1.3.0";
						#	sha256 = "15waf36j162i247z8c0dzd1807iww9gmwrnsc7w20i00x66k5gld";
						#}
						{
							name = "better-cpp-syntax";
							publisher = "jeff-hykin";
							version = "1.17.5";
							sha256 = "16dpgs4blis4yajw51yhby54pag28r74wwf6szx4nr79f44lgh7y";
						}
						{
							name = "vscode-todo-highlight";
							publisher = "jgclark";
							version = "2.0.4";
							sha256 = "18zm1w4ziq3i7fn2rcd095va7nqnbdmsvr82lj27s33zrd2wwzzr";
						}
						{
							name = "cmake-language-support-vscode";
							publisher = "josetr";
							version = "0.0.9";
							sha256 = "0apjsy1g12f0aqgpp320mk4p9c78ra62lplwjsslcbmrkrhmgnrc";
						}
						{
							name = "nim";
							publisher = "kosz78";
							version = "0.6.6";
							sha256 = "1s1npk6fzjngy6bjr65qgabsh6drkwmp2fmbpl3ryypjywpbmmdh";
						}
						{
							name = "vscode-dotnet-runtime";
							publisher = "ms-dotnettools";
							version = "1.6.0";
							sha256 = "047xkz2ka689d88mic4qp1ickjhrqnqzsx9c1rv630naycibjy83";
						}
						{
							name = "isort";
							publisher = "ms-python";
							version = "2023.9.10861010";
							sha256 = "1apsa9kgbz19wyy72vchka6wmfwwj2hy8chpqpppffr4qm2nkq1r";
						}
						{
							name = "vscode-pylance";
							publisher = "ms-python";
							version = "2023.3.31";
							sha256 = "09lm977r1bxm44lw7fiakjk4p9v5nhas3rdvgmwihzcpj7dm8v8p";
						}
						{
							name = "remote-containers";
							publisher = "ms-vscode-remote";
							version = "0.287.0";
							sha256 = "1zn3hzw9laagrjgg943g5nzydxiljq93ckb270fw0bjmab7hqi0c";
						}
						{
							name = "remote-ssh-edit";
							publisher = "ms-vscode-remote";
							version = "0.84.0";
							sha256 = "0rw2klz1f4sy1xzwg4bilcm2sjk0lxdfh9ly3f4kbl8a5xccfy6z";
						}
						{
							name = "remote-wsl";
							publisher = "ms-vscode-remote";
							version = "0.77.0";
							sha256 = "1q364nqwqbkvwzjisx64zc312graj5mcg43ha2vajwq30myivlbw";
						}
						{
							name = "cpptools-extension-pack";
							publisher = "ms-vscode";
							version = "1.3.0";
							sha256 = "11fk26siccnfxhbb92z6r20mfbl9b3hhp5zsvpn2jmh24vn96x5c";
						}
						{
							name = "cpptools-themes";
							publisher = "ms-vscode";
							version = "2.0.0";
							sha256 = "05r7hfphhlns2i7zdplzrad2224vdkgzb0dbxg40nwiyq193jq31";
						}
						{
							name = "remote-explorer";
							publisher = "ms-vscode";
							version = "0.3.2023032309";
							sha256 = "1wncgsw3ijf91fvl4w05xpz4wzc7h3l51ks2q4b99q3gylahlnxf";
						}
						{
							name = "Theme-MaterialKit";
							publisher = "ms-vscode";
							version = "0.1.4";
							sha256 = "1lqql7lb974mix00sad01d88d5mgyzrh1ck7xpgsdl5kqqag0w3a";
						}
						{
							name = "vsliveshare";
							publisher = "ms-vsliveshare";
							version = "1.0.5834";
							sha256 = "0xh719xmacgyn59xvbl4isb5xvg5i11bjmqpqra5pm8niyyy59zq";
						}
						#{
						#	name = "vscode-gnome-theme";
						#	publisher = "rafaelmardojai";
						#	version = "0.4.1";
						#	sha256 = "04z9jah2k6gph3zkjkk3ljlp1i7k0fd17qqwmqx4ngjmlmmq9197";
						#}
						{
							name = "gruvbox-material";
							publisher = "sainnhe";
							version = "6.5.2";
							sha256 = "0bpyb3a88ak1jb26d289fx5nmjwz8q960kj3r2p9g39h0h8rkr0g";
						}
						{
							name = "intellicode-api-usage-examples";
							publisher = "VisualStudioExptTeam";
							version = "0.2.7";
							sha256 = "09s3kv946hbpm1l4vks0vy6rl2vp451vbmr5bj16dd62s31pk4s8";
						}
						{
							name = "vscodeintellicode";
							publisher = "VisualStudioExptTeam";
							version = "1.2.30";
							sha256 = "0lg298047vmy31fnkczgpw78k3yxzpiip0ln1wixy70hdpwsfqbz";
						}
						{
							name = "vscodeintellicode-completions";
							publisher = "VisualStudioExptTeam";
							version = "1.0.21";
							sha256 = "0xwnmhh8l4p693r6hfsg8qk9cvjd91yz3inp26yjavdlp2sf78nh";
						}
						{
							name = "vscodeintellicode-insiders";
							publisher = "VisualStudioExptTeam";
							version = "1.1.10";
							sha256 = "1kf7vdm5gk346ki5k5wdnk57502j68wgjyg05f3sgbn7wrs5f307";
						}
						{
							name = "vscode-java-pack";
							publisher = "vscjava";
							version = "0.25.2023032708";
							sha256 = "1fn2rqxip1839iw2skv1wwymirzbsh9iynqhdp60gkimg2w36504";
						}
					];
		};
		gnome-terminal = {
			enable = true;
			themeVariant = "system";
			profile = {
				pearsche = {
					default = true;
					visibleName = "Default";
					allowBold = true;
					audibleBell = true;
					boldIsBright = true;
					scrollbackLines = 100000;
					transparencyPercent = 20;
				};
			};
		};
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
				# Likes to crash
				#vf="scale_vaapi=w=1920:h=1080:";
				vf="scale_vaapi=w=1920:h=1080:mode=hq:force_original_aspect_ratio=decrease";
				#blend-subtitles=true; # Enabling raises gpu usage considerably.
				deinterlace = "no"; # it's a default, but just in case
				#video-unscaled=true; # force vaapi scaling
				#scale="spline36";
				#cscale="spline36";
				#dscale="catmull_rom";
				linear-downscaling=true;
				correct-downscaling = true; # raises gpu usage, but less than sigmoid-upscaling
				sigmoid-upscaling = false; # raises gpu usage mildly, disable, perhaps uneeded.
				# Interpolation is way too expensive on a intel iris xe graphics igpu
				# tscale="oversample";
				# interpolation=true; # raises it a lil, least so far
				video-sync = "display-resample"; # raises gpu usage a bit
				video-sync-max-video-change = "5";
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
				# gamut-clipping was changed to gamut-mapping-mode
				#gamut-clipping = true; # default
				target-colorspace-hint = "yes";
				# target-prim = "auto"; # default
				# target-trc = "auto"; # default
				tone-mapping = "hable";
				hdr-compute-peak = "auto"; # intel gpu bug, value should be no
				
				# Removed in v0.35
				#gamma-factor = "1.1";
				#tone-mapping-param = "morbius";
				#icc-profile-auto = true;
				#icc-profile = "/home/${usernameCompat}/.local/share/icc/Lenovo Ideapad 5 15ITL05 sorta ok profile.icm";

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
				osd-font = "sans-serif";
				ytdl-raw-options = "no-sponsorblock=";

				# Cache
				cache = true;
				cache-secs = "120";

				# yt-dlp
				script-opts = "ytdl_hook-ytdl_path = yt-dlp";
				ytdl-format = "bestvideo+bestaudio/best";
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
		mangohud = {
			enable = true;
			settings = {
				### MangoHud configuration file
				### Uncomment any options you wish to enable. Default options are left uncommented
				### Use some_parameter=0 to disable a parameter (only works with on/off parameters)
				### Everything below can be used / overridden with the environment variable MANGOHUD_CONFIG instead

				################ PERFORMANCE #################

				### Limit the application FPS. Comma-separated list of one or more FPS values (e.g. 0,30,60). 0 means unlimited (unless VSynced)
				fps_limit = 60;

				### VSync [0-3] 0 = adaptive; 1 = off; 2 = mailbox; 3 = on
				# vsync=;

				### OpenGL VSync [0-N] 0 = off; >=1 = wait for N v-blanks, N > 1 acts as a FPS limiter (FPS = display refresh rate / N)
				# gl_vsync=;

				################### VISUAL ###################

				### Legacy layout
				# legacy_layout=false;

				### Display custom centered text, useful for a header
				# custom_text_center=;

				### Display the current system time
				time = true;

				### Time formatting examples
				time_format = "%H:%M";
				# time_format=[ %T %F ];
				# time_format=%X; # locally formatted time, because of limited glyph range, missing characters may show as '?' (e.g. Japanese)

				### Display MangoHud version
				version = true;

				### Display the current GPU information
				gpu_stats = true;
				gpu_temp = true;
				gpu_core_clock = true;
				gpu_mem_clock = true;
				gpu_power = true;
				gpu_text="GPU";
				gpu_load_change = true;
				gpu_load_value = "60,90";
				gpu_load_color = "39F900,FDFD09,B22222";

				### Display the current CPU information
				cpu_stats = true;
				cpu_temp = true;
				cpu_power = true;
				cpu_text = "CPU";
				cpu_mhz = true;
				cpu_load_change = true;
				cpu_load_value = "60,90" ;
				cpu_load_color = "39F900,FDFD09,B22222";

				### Display the current CPU load & frequency for each core
				core_load = true;
				core_load_change = true;

				### Display IO read and write for the app (not system)
				io_stats = true;
				io_read = true;
				io_write = true;

				### Display system vram / ram / swap space usage
				vram = true;
				ram = true;
				swap = true;

				### Display per process memory usage
				## Show resident memory and other types, if enabled
				procmem = true;
				procmem_shared = true;
				procmem_virt = true;

				### Display battery information
				battery = true;
				battery_icon = true;
				gamepad_battery = true;
				gamepad_battery_icon = true;

				### Display FPS and frametime
				fps = true;
				# fps_sampling_period=500;
				# fps_color_change;
				# fps_value=30,60;
				# fps_color=B22222,FDFD09,39F900;
				frametime = true;
				# frame_count;

				### Display miscellaneous information
				engine_version = true;
				gpu_name = true;
				vulkan_driver = true;
				wine = true;

				### Display loaded MangoHud architecture
				arch = true;

				### Display the frametime line graph
				frame_timing = true;
				histogram = true;

				### Display GameMode / vkBasalt running status
				gamemode = true;
				vkbasalt = true;

				### Display current FPS limit
				show_fps_limit = true;

				### Display the current resolution
				resolution = true;

				### Display custom text
				# custom_text=;
				### Display output of Bash command in next column
				# exec=;

				### Display media player metadata
				# media_player;
				# media_player_name=spotify;
				## Format metadata, lines are delimited by ; (wip)
				# media_player_format={title}\;{artist}\;{album} ;
				# media_player_format=Track:\;{title}\;By:\;{artist}\;From:\;{album} ;

				### Change the hud font size
				# font_size=24;
				# font_scale=1.0;
				# font_size_text=24;
				# font_scale_media_player=0.55;
				# no_small_font;

				### Change default font (set location to TTF/OTF file)
				## Set font for the whole hud
				font_file = "$(fc-match : file mono | sed \"s/:file=//g\")" ; # test if this works

				## Set font only for text like media player metadata
				# font_file_text=;

				## Set font glyph ranges. Defaults to Latin-only. Don't forget to set font_file/font_file_text to font that supports these
				## Probably don't enable all at once because of memory usage and hardware limits concerns
				## If you experience crashes or text is just squares, reduce glyph range or reduce font size
				# font_glyph_ranges=korean,chinese,chinese_simplified,japanese,cyrillic,thai,vietnamese,latin_ext_a,latin_ext_b;

				### Change the hud position
				# position=top-left;

				### Change the corner roundness
				# round_corners=;

				### Disable / hide the hud by default
				# no_display;

				### Hud position offset
				# offset_x=;
				# offset_y=;

				### Hud dimensions
				# width=;
				# height=;
				# table_columns=;
				# cellpadding_y=;

				### Hud transparency / alpha
				# background_alpha=0.5;
				# alpha=;

				### FCAT overlay
				### This enables an FCAT overlay to perform frametime analysis on the final image stream.
				### Enable the overlay
				# fcat;
				### Set the width of the FCAT overlay.
				### 24 is a performance optimization on AMD GPUs that should not have adverse effects on nVidia GPUs.
				### A minimum of 20 pixels is recommended by nVidia.
				# fcat_overlay_width=24;
				### Set the screen edge, this can be useful for special displays that don't update from top edge to bottom. This goes from 0 (left side) to 3 (top edge), counter-clockwise.
				# fcat_screen_edge=0;

				### Color customization
				# text_color=FFFFFF;
				# gpu_color=2E9762;
				# cpu_color=2E97CB;
				# vram_color=AD64C1;
				# ram_color=C26693;
				# engine_color=EB5B5B;
				# io_color=A491D3;
				# frametime_color=00FF00;
				# background_color=020202;
				# media_player_color=FFFFFF;
				# wine_color=EB5B5B;
				# battery_color=FF9078;

				### Specify GPU with PCI bus ID for AMDGPU and NVML stats
				### Set to 'domain:bus:slot.function'
				# pci_dev=0:0a:0.0;

				### Blacklist
				# blacklist=;

				### Control over socket
				### Enable and set socket name, '%p' is replaced with process id
				# control = mangohud;
				# control = mangohud-%p;

				################ WORKAROUNDS #################
				### Options starting with "gl_*" are for OpenGL
				### Specify what to use for getting display size. Options are "viewport", "scissorbox" or disabled. Defaults to using glXQueryDrawable
				# gl_size_query=viewport;

				### (Re)bind given framebuffer before MangoHud gets drawn. Helps with Crusader Kings III
				# gl_bind_framebuffer=0;

				### Don't swap origin if using GL_UPPER_LEFT. Helps with Ryujinx
				# gl_dont_flip=1;

				################ INTERACTION #################

				### Change toggle keybinds for the hud & logging
				# toggle_hud=Shift_R+F12;
				# toggle_fps_limit=Shift_L+F1;
				# toggle_logging=Shift_L+F2;
				# reload_cfg=Shift_L+F4;
				# upload_log=Shift_L+F3;

				#################### LOG #####################
				### Automatically start the log after X seconds
				# autostart_log=1;
				### Set amount of time in seconds that the logging will run for
				# log_duration=;
				### Change the default log interval, 100 is default
				# log_interval=100;
				### Set location of the output files (required for logging)
				# output_folder=/home/<USERNAME>/mangologs;
				### Permit uploading logs directly to FlightlessMango.com
				# permit_upload=1;
				### Define a '+'-separated list of percentiles shown in the benchmark results
				### Use "AVG" to get a mean average. Default percentiles are 97+AVG+1+0.1
				# benchmark_percentiles=97,AVG,1,0.1;
			};
		};
		nix-index = {
			enable = true;
		};
	};
}
