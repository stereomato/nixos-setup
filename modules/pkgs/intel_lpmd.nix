{
  lib,
  stdenv,
  fetchFromGitHub,

  autoreconfHook,
  pkg-config,

  # This was fixed too
  dbus,
  dbus-glib,

  glib,
  gtk-doc,
  libnl,
  libxml2,
  systemd,
  upower,

  coreutils,

  writers,
}:
# This is needed because neither intel_lpmd or thermald can read configuration files in the system put in
# /etc, for some reason.
# And, intel_lpmd doesn't have a flag to load a configuration file directly, at least until
# https://github.com/intel/intel-lpmd/issues/84 is fixed
# Accepts           <EnterGFXLoadThres>50</EnterGFXLoadThres> for gpu stuff

let workaround = writers.writeText "config-file.xml" ''
  <?xml version="1.0"?>

    <!--
    Specifies the configuration data
    for Intel Energy Optimizer (LPMD) daemon
    -->

    <Configuration>
      <!--
        CPU format example: 1,2,4..6,8-10
      -->
      <lp_mode_cpus>8-15</lp_mode_cpus>

      <!--
        Mode values
        0: Cgroup v2
        1: Cgroup v2 isolate
        2: CPU idle injection
      -->
      <Mode>0</Mode>

      <!--
        Default behavior when Performance power setting is used
        -1: force off. (Never enter Low Power Mode)
        1: force on. (Always stay in Low Power Mode)
        0: auto. (opportunistic Low Power Mode enter/exit)
      -->
      <PerformanceDef>-1</PerformanceDef>

      <!--
        Default behavior when Balanced power setting is used
        -1: force off. (Never enter Low Power Mode)
        1: force on. (Always stay in Low Power Mode)
        0: auto. (opportunistic Low Power Mode enter/exit)
      -->
      <BalancedDef>0</BalancedDef>

      <!--
        Default behavior when Power saver setting is used
        -1: force off. (Never enter Low Power Mode)
        1: force on. (Always stay in Low Power Mode)
        0: auto. (opportunistic Low Power Mode enter/exit)
      -->
      <PowersaverDef>0</PowersaverDef>

      <!--
        Use HFI LPM hints
        0 : No
        1 : Yes
      -->
      <HfiLpmEnable>0</HfiLpmEnable>

      <!--
        Use HFI SUV hints
        0 : No
        1 : Yes
      -->
      <HfiSuvEnable>0</HfiSuvEnable>
      
      <!--
        Use WLT hints
        0 : No
        1 : Yes
      -->
      <WLTHintEnable>1</WLTHintEnable>
      
      <!--
        Use WLT hint Poll enable
        0 : No
        1 : Yes
      -->
      <WLTHintPollEnable>1</WLTHintPollEnable>

      <!--
        Use WLT software proxy hints
        0 : No
        1 : Yes
      -->
    <WLTProxyEnable>1</WLTProxyEnable>

      <!--
        System utilization threshold to enter LP mode
        from 0 - 100
        clear both util_entry_threshold and util_exit_threshold to disable util monitor
      -->
      <util_entry_threshold>20</util_entry_threshold>

      <!--
        System utilization threshold to exit LP mode
        from 0 - 100
        clear both util_entry_threshold and util_exit_threshold to disable util monitor
      -->
      <util_exit_threshold>75</util_exit_threshold>

      <!--
        Entry delay. Minimum delay in non Low Power mode to
        enter LPM mode.
      -->
      <EntryDelayMS>0</EntryDelayMS>

      <!--
        Exit delay. Minimum delay in Low Power mode to
        exit LPM mode.
      -->
      <ExitDelayMS>0</ExitDelayMS>

      <!--
        Lowest hysteresis average in-LP-mode time in msec to enter LP mode
        0: to disable hysteresis support
      -->
      <EntryHystMS>0</EntryHystMS>

      <!--
        Lowest hysteresis average out-of-LP-mode time in msec to exit LP mode
        0: to disable hysteresis support
      -->
      <ExitHystMS>0</ExitHystMS>

      <!--
        Ignore ITMT setting during LP-mode enter/exit
        0: disable ITMT upon LP-mode enter and re-enable ITMT upon LP-mode exit
        1: do not touch ITMT setting during LP-mode enter/exit
      -->
      <IgnoreITMT>0</IgnoreITMT>

    <States>
      <CPUFamily> 6 </CPUFamily>
      <CPUModel> 154 </CPUModel>
      <CPUConfig> * </CPUConfig>
      <State>
          <ID> 1 </ID> <!-- no significance. number can be anything -->
          <Name> WLT_IDLE </Name>
          <WLTType> 0 </WLTType> <!-- WLTType mapped to Name -->
          <EPP> 170 </EPP>
          <EPB> 13 </EPB>
          <EnterGFXLoadThres>25</EnterGFXLoadThres>
          <EntrySystemLoadThres>5</EntrySystemLoadThres>
          <EnterCPULoadThres>25</EnterCPULoadThres>
          <MinPollInterval> 1000 </MinPollInterval>
          <PollIntervalIncrement> 500 </PollIntervalIncrement>
          <MaxPollInterval> 2000 </MaxPollInterval>
          <ActiveCPUs>lp</ActiveCPUs>
          <ITMTState> -1 </ITMTState>
          <IRQMigrate> -1 </IRQMigrate>
      </State>
      <State>
          <ID> 2 </ID>
          <Name> WLT_BATTERY_LIFE </Name>
          <WLTType> 1 </WLTType>
          <EPP> 119 </EPP>
          <EPB> 10 </EPB>
          <EnterGFXLoadThres>35</EnterGFXLoadThres>
          <EntrySystemLoadThres>10</EntrySystemLoadThres>
          <EnterCPULoadThres>35</EnterCPULoadThres>
          <MinPollInterval> 1000 </MinPollInterval>
          <PollIntervalIncrement> 500 </PollIntervalIncrement>
          <MaxPollInterval> 2000 </MaxPollInterval>
          <ActiveCPUs>lp</ActiveCPUs>
          <ITMTState> -1 </ITMTState>
          <IRQMigrate> -1 </IRQMigrate>
      </State>
      <State>
          <ID> 3 </ID>
          <Name> WLT_SUSTAINED </Name>
          <WLTType> 2 </WLTType>
          <EPP> 119 </EPP>
          <EPB> 7 </EPB>
          <EntrySystemLoadThres>30</EntrySystemLoadThres>
          <EnterGFXLoadThres>50</EnterGFXLoadThres>
          <MinPollInterval> 1000 </MinPollInterval>
          <PollIntervalIncrement> 500 </PollIntervalIncrement>
          <MaxPollInterval> 2000 </MaxPollInterval>
          <ActiveCPUs>all</ActiveCPUs>
          <ITMTState> -1 </ITMTState>
          <IRQMigrate> -1 </IRQMigrate>
      </State>
      <State>
          <ID> 4 </ID>
          <Name> WLT_BURSTY </Name>
          <WLTType> 3 </WLTType>
          <EPP> 34 </EPP>
          <EPB> 2 </EPB>
          <EnterGFXLoadThres>50</EnterGFXLoadThres>
          <EntrySystemLoadThres>50</EntrySystemLoadThres>
          <MinPollInterval> 1000 </MinPollInterval>
          <PollIntervalIncrement> 500 </PollIntervalIncrement>
          <MaxPollInterval> 2000 </MaxPollInterval>
          <ActiveCPUs>all</ActiveCPUs>
          <ITMTState> -1 </ITMTState>
          <IRQMigrate> -1 </IRQMigrate>
      </State>
    </States>

  </Configuration>

'';
in stdenv.mkDerivation (finalAttrs: {
  pname = "intel_lpmd";
  version = "0.0.9";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-lpmd";
    rev = "afe44487750e58992004471b96ef7914bb07c848";
    hash = "sha256-IygTSDz9l2xwctDwe6El+/jEKy3PFCvavCqgaPqSdbo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config

    glib
    gtk-doc
    libnl
    # And here
    systemd
    upower
  ];

  # Here too
  buildInputs = [
    dbus
    dbus-glib
    libxml2
  ];

  postPatch = ''
    substituteInPlace "data/org.freedesktop.intel_lpmd.service.in" \
    --replace-fail "/bin/false" "${lib.getExe' coreutils "false"}"

  #   substituteInPlace "src/lpmd_dbus_server.c" \
  #     --replace-fail "src/intel_lpmd_dbus_interface.xml" "${placeholder "out"}/share/dbus-1/interfaces/org.freedesktop.intel_lpmd.xml"
  '';

  configureFlags = [
    # here too lmao
    "--sysconfdir=${placeholder "out"}/etc"
    "--localstatedir=/var"
    ''--with-dbus-sys-dir="${placeholder "out"}/share/dbus-1/system.d"''
    ''--with-systemdsystemunitdir="${placeholder "out"}/lib/systemd/system"''
  ];

  postInstall = ''
    install -Dm644 src/intel_lpmd_dbus_interface.xml $out/share/dbus-1/interfaces/org.freedesktop.intel_lpmd.xml

    cp ${workaround} $out/etc/intel_lpmd/intel_lpmd_config.xml
  '';

  meta = with lib; {
    homepage = "https://github.com/intel/intel-lpmd";
    description = "Linux daemon used to optimize active idle power.";
    longDescription = ''
      Intel Low Power Model Daemon is a Linux daemon used to optimize active
      idle power. It selects a set of most power efficient CPUs based on
      configuration file or CPU topology. Based on system utilization and other
      hints, it puts the system into Low Power Mode by activate the power
      efficient CPUs and disable the rest, and restore the system from Low Power
      Mode by activating all CPUs.
    '';

    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ frontear ];

    mainProgram = "intel_lpmd";
  };
})