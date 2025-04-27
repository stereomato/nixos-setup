# Named like this since I don't intend this to be used by others really, stuff gets weird
# given personal experience
let myOverlays = (
  final: prev: {
    winetricks = prev.winetricks.overrideAttrs (old: {
      patches = [ ./patches/winetricks-fix.patch ];
    });
    intel_lpmd = prev.callPackage ./modules/pkgs/intel_lpmd.nix {};
    # Make ppd only use balance-performance
		# TODO: https://gitlab.freedesktop.org/upower/power-profiles-daemon/-/issues/151
		power-profiles-daemon = prev.power-profiles-daemon.overrideAttrs (old: {
			patches = prev.power-profiles-daemon.patches ++ [ ./patches/ppd-intel-balance-performance.patch ];
		});
    # Zen kernel
    # TODO: Find where this comes from, and how it works? But, https://github.com/shiryel/nixos-dotfiles/blob/master/overlays/overrides/linux/default.nix# helped a lot!
    linux-stereomato-zen = prev.linuxPackages_zen.extend (kfinal: kprev: {
      kernel = kprev.kernel.override {
        argsOverride = {
          structuredExtraConfig = with prev.lib.kernel;
            # Merge the zen kernel's own config with this one using the // operator
            prev.linuxPackages_zen.kernel.structuredExtraConfig // {
              # Zswap stuff
              ZSWAP_SHRINKER_DEFAULT_ON = yes;
              ZSMALLOC_STAT = yes;
              # This needs "freeform"
              # from https://github.com/NixOS/nixpkgs/blob/73cf49b8ad837ade2de76f87eb53fc85ed5d4680/pkgs/os-specific/linux/kernel/zen-kernels.nix#L82
              ZSMALLOC_CHAIN_SIZE = freeform "10";
              # mgLRU statistics support
              LRU_GEN_STATS = yes;
              # Compile the kernel with optimizations for my Intel laptop.
              MALDERLAKE = yes;
              # Extra zram stuff
              ZRAM_MEMORY_TRACKING = yes;
              ZRAM_TRACK_ENTRY_ACTIME = yes;

              # Module compression with ZSTD
              MODULE_COMPRESS_XZ = prev.lib.mkForce no;
              MODULE_COMPRESS_ZSTD = yes;

              # Hibernation compressor set to LZ4
              HIBERNATION_COMP_LZ4 = yes;
              HIBERNATION_DEF_COMP = freeform "lz4";
            };
        };
        ignoreConfigErrors = true;
      };
    });

    # Default
    linux-stereomato = prev.linuxPackages_latest.extend (kfinal: kprev: {
      kernel = kprev.kernel.override {
        argsOverride = {
          structuredExtraConfig = with prev.lib.kernel;
            # Merge the kernel's own config with this one using the // operator
            prev.linuxPackages_latest.kernel.structuredExtraConfig // {
              # Zswap stuff
              ZSWAP_SHRINKER_DEFAULT_ON = yes;
              ZSMALLOC_STAT = yes;
              # This needs "freeform"
              # from https://github.com/NixOS/nixpkgs/blob/73cf49b8ad837ade2de76f87eb53fc85ed5d4680/pkgs/os-specific/linux/kernel/zen-kernels.nix#L82
              ZSMALLOC_CHAIN_SIZE = freeform "10";
              # mgLRU statistics support
              LRU_GEN_STATS = yes;
              # Compile the kernel with optimizations for my Intel laptop.
              # MNATIVE_INTEL = yes;
              # Extra zram stuff
              ZRAM_MEMORY_TRACKING = yes;
              ZRAM_TRACK_ENTRY_ACTIME = yes;

              # Module compression with ZSTD
              MODULE_COMPRESS_XZ = prev.lib.mkForce no;
              MODULE_COMPRESS_ZSTD = yes;

              # Hibernation compressor set to LZ4
              HIBERNATION_COMP_LZ4 = yes;
              HIBERNATION_DEF_COMP = freeform "lz4";
            };
        };
        ignoreConfigErrors = true;
      };
    });

    threadsFile = prev.runCommandLocal "cores-for-hardware-config" {} '' 
      mkdir $out
      nproc | tr -d '\n' | tee $out/numThreads
      echo '''$(($(nproc) / 2 ))| tr -d '\n' | tee $out/halfNumThreads
    '';
    nvtop = prev.nvtop.override {
      nvidia = false;
    };

    # UGLY, see: https://github.com/NixOS/nix/pull/2911
    # Also, see: https://github.com/NixOS/nixpkgs/issues/214848
    emoji-removal = prev.writeScriptBin "emoji-removal" ''
          #!/usr/bin/env -S ${prev.fontforge}/bin/fontforge -lang=ff -script
          Open($1)
          SetTTFName(0x409,13,"")
          Select(0u2600,0u26ff)
          DetachAndRemoveGlyphs()
          Generate($1)
          Select(0u2700,0u27bf)
          DetachAndRemoveGlyphs()
          Generate($1)
          Select(0u10000,0u1fffd)
          DetachAndRemoveGlyphs()
          Generate($1)
        '';
    # [buildPlans.IosevkaCustom]
    # family = "Iosevka Custom"
    # spacing = "normal"
    # serifs = "sans"
    # noCvSs = false
    # exportGlyphNames = true

    # [buildPlans.IosevkaCustom.variants.design]
    # eight = "two-circles"
    # capital-g = "toothed-serifed-hooked"
    # capital-q = "crossing-baseline"
    # f = "flat-hook-serifless"
    # g = "single-storey-flat-hook-serifless"
    # r = "serifed"
    # t = "flat-hook-short-neck2"
    # paren = "flat-arc"
    # brace = "straight"
    # guillemet = "straight"
    # at = "fourfold-solid-inner"
    # [buildPlans.IosevkaCustom.widths.Normal]
    # shape = 500
    # menu = 5
    # css = "normal"

    # [buildPlans.IosevkaCustom.widths.Extended]
    # shape = 600
    # menu = 7
    # css = "expanded"

    # [buildPlans.IosevkaCustom.widths.Condensed]
    # shape = 416
    # menu = 3
    # css = "condensed"

    # [buildPlans.IosevkaCustom.widths.SemiCondensed]
    # shape = 456
    # menu = 4
    # css = "semi-condensed"

    # [buildPlans.IosevkaCustom.widths.SemiExtended]
    # shape = 548
    # menu = 6
    # css = "semi-expanded"

    # [buildPlans.IosevkaCustom.widths.ExtraExtended]
    # shape = 658
    # menu = 8
    # css = "extra-expanded"

    # [buildPlans.IosevkaCustom.widths.UltraExtended]
    # shape = 720
    # menu = 9
    # css = "ultra-expanded"
    iosevka-stereomato = prev.iosevka.override {
      privateBuildPlan = {
        family = "stereomato's Iosevka setup";
        spacing = "normal";
        serifs = "sans";
        noCvSs = false;
        exportGlyphNames = true;
        variants = {
          design = {
            capital-g = "toothed-serifless-hooked";
            capital-j = "serifed";
            capital-q = "crossing-baseline";
            f = "flat-hook-serifless";
            g = "single-storey-flat-hook-serifless";
            r = "serifed";
            t = "flat-hook-short-neck2";
            eight = "two-circles";
            at = "fourfold-solid-inner";
            paren = "flat-arc";
            brace = "straight";
            guillemet = "straight";
          };
        };
        widths.normal = {
          shape = 500;
          menu = 5;
          css = "normal";
        };
        widths.extended = {
          shape = 600;
          menu = 7;
          css = "expanded";
        };
        widths.condensed = {
          shape = 416;
          menu = 3;
          css = "condensed";
        };
        widths.semicondensed = {
          shape = 456;
          menu = 4;
          css = "semi-condensed";
        };
        widths.semiextended = {
          shape = 548;
          menu = 6;
          css = "semi-expanded";
        };
        widths.extraextended = {
          shape = 658;
          menu = 8;
          css = "extra-expanded";
        };
        widths.ultraextended = {
          shape = 720;
          menu = 9;
          css = "ultra-expanded";
        };
      };
      set = "Iosevka-stereomato";
    };
    SF-Pro = prev.callPackage ./localDerivations/SF-Pro.nix {};
    SF-Compact = prev.callPackage ./localDerivations/SF-Compact.nix {};
    SF-Mono = prev.callPackage ./localDerivations/SF-Mono.nix {};
    SF-Arabic = prev.callPackage ./localDerivations/SF-Arabic.nix {};
    New-York = prev.callPackage ./localDerivations/New-York.nix {};
    Bitter-Pro = prev.callPackage ./localDerivations/Bitter-Pro.nix {};
    Playfair-Display = prev.callPackage ./localDerivations/Playfair-Display.nix {};
    ANRT-Baskervville = prev.callPackage ./localDerivations/ANRT-Baskervville.nix {};
    input-fonts = prev.input-fonts.overrideAttrs (old: {
      pname = "${prev.input-fonts.pname}";
      version = "${prev.input-fonts.version}";
      src =
        prev.fetchzip {
          name = "${prev.input-fonts.pname}-${prev.input-fonts.version}";
          url = "https://input.djr.com/build/?fontSelection=whole&a=0&g=ss&i=serif&l=serif&zero=slash&asterisk=0&braces=straight&preset=default&line-height=1.2&accept=I+do&email=&.zip";
          hash = "sha256-trtXHQa/1q21T4SXLq2XzFvU5pa5C4U3zqFqzyYXKVY=";
          sha256 = "";
          stripRoot = false;
        };
    });

    # Overlay to make jetbrains mono install the variable font only
    jetbrains-mono-variable = prev.jetbrains-mono.overrideAttrs (old: {
      # From the original, here I only remove the line that installs the non-variable font files
      installPhase = ''
        runHook preInstall
        install -Dm644 -t $out/share/fonts/truetype/ fonts/variable/*.ttf
        runHook postInstall
      '';
    });

    commit-mono-stereomato-script = prev.writers.writeFishBin "cmsc" ''
      set -l options 'srcPath=' 'localPath=' 'fontFormat='
      argparse $options -- $argv

      set command ${prev.python3Packages.opentype-feature-freezer}/bin/pyftfeatfreeze

      for font in "$_flag_srcPath"/*."$_flag_fontFormat"
        # This enables those flags, and gets the font filename (without the .otf) to save the font file
        $command -f 'ss03,ss04,ss05,cv02,cv06,cv10' -S -U Stereomato -R 'CommitMonoV143/CommitMono' $font "$_flag_localPath"/(string replace .otf "" (string replace "$_flag_srcPath" "" $font))-Stereomato."$_flag_fontFormat"
        
        # Delete the original fonts
        rm $_flag_localPath/(string replace "$_flag_srcPath" "" $font)
      end
    '';

    commit-mono-stereomato = prev.callPackage ./localDerivations/commit-mono-stereomato.nix {};


    # prev.commit-mono.overrideAttrs(old: {
    #   postInstall = ''
    #     ${prev.commit-mono-stereomato-script}/bin/cmsc
    #   '';
    # });


    # This is so that the Inter variant I use is the otf one
    # because KDE/QT do stem darkening on OTF fonts only.
    inter-otf = prev.inter.overrideAttrs (old: {
      pname = "inter-otf";
      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/fonts/otf
        cp extras/otf/*.otf $out/share/fonts/otf

        runHook postInstall
      '';
    });

    ydotool = prev.ydotool.overrideAttrs(old: {
      src = prev.fetchFromGitHub {
        owner = "stereomato";
        repo = "ydotool";
        rev = "8e8a3d0776b59bf030c45a1458aa55473faa2400";
        hash = "sha256-MtanR+cxz6FsbNBngqLE+ITKPZFHmWGsD1mBDk0OVng=";
      };
    });

    steam = prev.steam.override {
      extraPkgs = pkgs: with pkgs; [
        openssl_1_1
        curl
        libssh2
        openal
        zlib
        libpng
        # https://github.com/NixOS/nixpkgs/issues/236561
        attr
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    };

    chowmatrix = prev.callPackage ./localDerivations/chowmatrix.nix {};
    auburn-sounds-graillon-2 = prev.callPackage ./localDerivations/auburn-sounds-graillon-2.nix {};
    tal-reverb-4 = prev.callPackage ./localDerivations/tal-reverb-4.nix {};
    obs-studio-with-plugins = prev.wrapOBS {
      plugins = with prev.obs-studio-plugins; [
        obs-vkcapture
        obs-vaapi
      ];
    };
    handbrake-stereomato = prev.handbrake.override {
      useFdk = true;
    };
    ffmpeg-fuller = prev.ffmpeg-full.override {
      withUnfree = true;
      # enableLto = true; # fails...
    };
    # FIXME: https://github.com/NixOS/nixpkgs/pull/294710
    gimp-stereomato = prev.gimp.override {
      withPython = true;
    };

    vscode = prev.vscode.override {
			commandLineArgs = "--disable-font-subpixel-positioning=true";
    };
    # TODO: Adapt this to use forVSCodeVersion
    my-vscode = prev.vscode-with-extensions.override { 
      vscodeExtensions = [
        # Superseded by the direnv extension
        #prev.vscode-marketplace.arrterian.nix-env-selector
        prev.vscode-marketplace.donjayamanne.githistory
        prev.vscode-marketplace.eamodio.gitlens
        prev.vscode-marketplace.formulahendry.code-runner
        prev.vscode-marketplace.github.github-vscode-theme
        prev.vscode-marketplace.github.vscode-pull-request-github
        prev.vscode-marketplace.jnoortheen.nix-ide
        prev.vscode-marketplace.mkhl.direnv
        prev.vscode-marketplace.ms-python.python
        prev.vscode-marketplace.ms-toolsai.jupyter
        prev.vscode-marketplace.ms-toolsai.jupyter-keymap
        prev.vscode-marketplace.ms-toolsai.jupyter-renderers
        # prev.vscode-marketplace.ms-dotnettools.csdevkit
        # prev.vscode-marketplace.ms-dotnettools.csharp
        # prev.vscode-marketplace.ms-dotnettools.vscode-dotnet-runtime
        prev.vscode-marketplace.ms-vscode.remote-server
        prev.vscode-marketplace.ms-vscode-remote.remote-ssh
        prev.vscode-marketplace.ms-vscode.cmake-tools
        # https://github.com/nix-community/nix-vscode-extensions/issues/69
        prev.vscode-extensions.ms-vscode.cpptools
        prev.vscode-marketplace.ms-vscode.hexeditor
        prev.vscode-marketplace.ms-vscode.theme-tomorrowkit
        prev.vscode-marketplace.piousdeer.adwaita-theme
        prev.vscode-marketplace.pkief.material-product-icons
        prev.vscode-marketplace.pkief.material-icon-theme
        prev.vscode-marketplace.redhat.java
        prev.vscode-marketplace.rust-lang.rust-analyzer
        # prev.vscode-marketplace.skyapps.fish-vscode
        prev.vscode-marketplace.vscjava.vscode-java-debug
        prev.vscode-marketplace.vscjava.vscode-java-dependency
        prev.vscode-marketplace.vscjava.vscode-java-test
        prev.vscode-marketplace.vscjava.vscode-maven
        prev.vscode-marketplace.vadimcn.vscode-lldb
        prev.vscode-marketplace.nimlang.nimlang
        prev.vscode-marketplace.cschlosser.doxdocgen
        prev.vscode-marketplace.jeff-hykin.better-cpp-syntax
        # prev.vscode-marketplace.jgclark.vscode-todo-highlight
        prev.vscode-marketplace.josetr.cmake-language-support-vscode
        
        prev.vscode-marketplace.ms-python.isort
        prev.vscode-marketplace.ms-python.vscode-pylance
        prev.vscode-marketplace.ms-vscode-remote.remote-containers
        prev.vscode-marketplace.ms-vscode-remote.remote-ssh-edit
        prev.vscode-marketplace.ms-vscode-remote.remote-wsl
        prev.vscode-marketplace.ms-vscode.cpptools-extension-pack
        prev.vscode-marketplace.ms-vscode.cpptools-themes
        prev.vscode-marketplace.ms-vscode.remote-explorer
        # https://github.com/nix-community/nix-vscode-extensions/issues/97
        prev.vscode-marketplace.ms-vsliveshare.vsliveshare
        prev.vscode-marketplace.jdinhlife.gruvbox
        #prev.vscode-marketplace.VisualStudioExptTeam.intellicode-api-usage-examples
        #prev.vscode-marketplace.VisualStudioExptTeam.vscodeintellicode
        #prev.vscode-marketplace.VisualStudioExptTeam.vscodeintellicode-completions
        #prev.vscode-marketplace.VisualStudioExptTeam.vscodeintellicode-insiders
        prev.vscode-marketplace.vscjava.vscode-java-pack
        prev.vscode-marketplace.gruntfuggly.todo-tree
        prev.vscode-marketplace.bmalehorn.vscode-fish
        prev.vscode-marketplace.dart-code.dart-code
        prev.vscode-marketplace.dart-code.flutter
        prev.vscode-marketplace.dart-code.flutter-local-device-exposer
        prev.vscode-marketplace.elixir-tools.elixir-tools
        
        # This was confusing...
        prev.vscode-marketplace.jakebecker.elixir-ls
      ] ++ 
      prev.vscode-utils.extensionsFromVscodeMarketplace [
      ];
    };

    google-chrome = prev.google-chrome.override {
      commandLineArgs = "--enable-features=Vulkan,VulkanFromANGLE,TouchpadOverscrollHistoryNavigation,AcceleratedVideoEncoder,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,ParallelDownloading,UseMultiPlaneFormatForHardwareVideo,WaylandLinuxDrmSyncobj,WaylandPerSurfaceScale,WaylandTextInputV3,WaylandUiScale --disable-font-subpixel-positioning=true --enable-zero-copy=true --use-vulkan=true --enable-hardware-overlays=true";
      # commandLineArgs = "--enable-features=TouchpadOverscrollHistoryNavigation,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,ParallelDownloading,UseMultiPlaneFormatForHardwareVideo,WaylandLinuxDrmSyncobj,WaylandPerSurfaceScale,WaylandTextInputV3,WaylandUiScale --disable-font-subpixel-positioning=true --enable-zero-copy=true";
    };
  }
); 
in myOverlays