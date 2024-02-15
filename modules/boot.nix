{ pkgs, ... }:
{
	boot = {
		plymouth = {
			enable = true;
			font = "${pkgs.inter}/share/fonts/truetype/InterVariable.ttf";
		};
		kernel.sysctl = {
			# Memory
			# Disable swap read ahead, increases latency when dealing with swap and it's rather meaningless when using zram+zstd anyway
			"vm.page-cluster" = 0;
			# Hugepages configuration, mostly for xmrig
			# Not needed anymore
			#"vm.nr_hugepages" = 25;
			#"vm.nr_overcommit_hugepages" = 150;
			# Prefer to keep filesystem cache memory over application memory
			"vm.vfs_cache_pressure" = 250;
			# Proper swappiness
			"vm.swappiness" = 150;
			# Set the bytes of my current laptop's storage speed
			# dirty_bytes is set using  75% of the write speed obtained from the benchmark runs, using the NVME SSD preset
			# dirty_bytes uses peak performance profile
			# dirty_background_bytes is set by dividing dirty_bytes by 8
			# actual value is 1000000000
			"vm.dirty_bytes" = 500000000;
			"vm.dirty_background_bytes" = 125000000;
			# 5% physical ram
			"vm.min_free_kbytes" = 308229;
			# Best value, according to phoronix
			"vm.page_lock_unfairness" = 3;
			# Disable watermark boosting
			#"vm.watermark_boost_factor" = 0; # Needed when not using the zen-kernel
			# Increase kswapd activity
			# When free memory is less than 2.5%, make kswapd kick in.
			# https://unix.stackexchange.com/a/679203
			"vm.watermark_scale_factor" = 150;
			# Increase the compaction activity slightly
			#"vm.compaction_proactiveness" = 25;
			# Compact also unevictable memory (testing)
			#"vm.compact_unevictable_allowed" = 1;
			
			# Fedora change, for some games. Shouldn't affect most things
			# Higher memory map count for some games that need it
			# https://www.phoronix.com/news/Fedora-39-Max-Map-Count-Approve
			"vm.max_map_count" = 1048576;

			# Internet
			"net.ipv4.tcp_fastopen" = 3;
			"net.ipv4.tcp_low_latency" = 1;
			"net.ipv4.tcp_ecn" = 1;
			"net.ipv4.tcp_congestion_control" = "bbr";

			# Cpu
			#"kernel.sched_child_runs_first" = 1;
			#"kernel.sched_cfs_bandwidth_slice_us" = 3000;
			#"kernel.perf_cpu_time_max_percent" = 3;
			
			# Intel GPU
			# Disable the paranoid mode over some stats
			"dev.i915.perf_stream_paranoid" = 0;
		};
		initrd = {
			availableKernelModules = [ "i915" "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
			kernelModules = [ ];
			luks = {
				mitigateDMAAttacks = true;
				devices = {
					"TaihouDisk" = {
						device = "/dev/disk/by-uuid/66c2a68f-2173-47bb-b430-7a698b51a049";
						allowDiscards = true;
						bypassWorkqueues = true;
					};
				};
			};
		};
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [ ];
		kernelPackages = pkgs.linux-stereomato;
		kernelPatches = [
			{
				name = "FBC patch";
				patch = ./patches/drm-i915-fbc-Allow-FBC-with-CCS-modifiers-on-SKL.patch;
			}
		];
		kernelParams = [ 
			# Find out whether this is a good idea or not
			#"pcie_aspm=force"
			"preempt=full"
			# For TGL: only enable the HuC
			# For ADL and up, GuC is enabled automatically.
			"i915.enable_guc=2"
			# PSR stuff, should help with battery saving on laptop displays that support this
			#"i915.enable_psr=1"
			#"i915.enable_psr2_sel_fetch=1"
			#"i915.enable_psr=1"
			#"i915.enable_psr2_sel_fetch=1"
			# Powersaving
			"iwlwifi.power_save=1"
			"iwlwifi.power_level=3"
			# Zswap settings
			"zswap.enabled=N"
			"zswap.compressor=zstd"
			"zswap.zpool=zsmalloc"
			"zswap.max_pool_percent=25"
			"zswap.accept_threshold_percent=95"
		];
		loader = {
			systemd-boot = {
				enable = true;
				# configurationLimit = 10;
			};
			efi = {
				canTouchEfiVariables = true;
				efiSysMountPoint = "/boot";
			};
		};
	};
}
