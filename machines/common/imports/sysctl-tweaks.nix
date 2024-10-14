{ ... }:{
	boot.kernel.sysctl = {
			# Memory
			# Disable swap read ahead, increases latency when dealing with swap and it's rather meaningless when using zram+zstd anyway
			"vm.page-cluster" = 0;
			# Hugepages configuration, mostly for xmrig
			# Not needed anymore
			"vm.nr_hugepages" = 25;
			"vm.nr_overcommit_hugepages" = 150;
			# Prefer to keep filesystem cache memory over application memory
			"vm.vfs_cache_pressure" = 150;
			# Proper swappiness
			"vm.swappiness" = 150;
			# Set the bytes of my current laptop's storage speed
			# dirty_bytes is 3x of the total speed
			# dirty_background_bytes is the total random writes speed
			# as shown by kdiskmark
			"vm.dirty_bytes" = 498000000;
			"vm.dirty_background_bytes" = 166000000;
			# 1.25% of RAM
			"vm.min_free_kbytes" = 152663;
			# Best value, according to phoronix
			"vm.page_lock_unfairness" = 3;
			# Disable watermark boosting
			"vm.watermark_boost_factor" = 0; # Needed when not using the zen-kernel
			# Increase kswapd activity
			# When free memory is less than 1.5%, make kswapd kick in.
			# https://unix.stackexchange.com/a/679203
			"vm.watermark_scale_factor" = 150;
			# Increase the compaction activity slightly
			"vm.compaction_proactiveness" = 0;
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

			# Kernel delay task accounting
			"kernel.task_delayacct" = 1;

		};
}
