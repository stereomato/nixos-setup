{ lib, pkgs, ... }:
{
	boot = {
		plymouth = {
			enable = true;
			font = "${pkgs.inter}/share/fonts/opentype/Inter-Regular.otf";
		};
		kernel.sysctl = {
			# Memory
			"vm.page-cluster" = 0;
			"vm.nr_hugepages" = 25;
			"vm.nr_overcommit_hugepages" = 150;
			"vm.vfs_cache_pressure" = 50;
			"vm.swappiness" = 200;
			#"vm.dirty_ratio"= 6;
			#"vm.dirty_background_ratio" = 1;
			# Set the bytes of my current laptop's storage speed
			"vm.dirty_bytes" = 1000000000;
			"vm.dirty_background_bytes" = 1800000000;
			"vm.min_free_kbytes" = 77050;
			"vm.page_lock_unfairness" = 3;
			#"vm.watermark_boost_factor" = 0; # Needed when not using the zen-kernel
			"vm.watermark_scale_factor" = 375;
			"vm.compaction_proactiveness" = 25;
			"vm.compact_unevictable_allowed" = 1;

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
			"dev.i915.perf_stream_paranoid" = 0;
		};
		initrd = {
			availableKernelModules = [ "i915" "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
			kernelModules = [ ];
			luks = {
				mitigateDMAAttacks = true;
				devices = {
					"Taihou-Main" = {
						device = "/dev/disk/by-uuid/b9d5979c-bd51-4b40-a759-d24cce9e4c09";
						allowDiscards = true;
						bypassWorkqueues = true;
					};
				};
			};
		};
		
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [ ];
		kernelPackages = pkgs.linux-pearsche;
		kernelParams = [ 
			# Find out whether this is a good idea or not
			#"pcie_aspm=force"
			"preempt=full"
			"i915.enable_guc=3"
			"i915.enable_psr2_sel_fetch=1"
			"iwlwifi.power_save=Y"
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