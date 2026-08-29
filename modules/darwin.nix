{
  config,
  lib,
  pkgs,
  ...
}:

let
  dockApp = path: {
    tile-data.file-data = {
      _CFURLString = "file://${path}/";
      _CFURLStringType = 15;
    };
    tile-type = "file-tile";
  };
in
lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
  targets.darwin.defaults = {
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;

      AppleActionOnDoubleClick = "Maximize";
      AppleInterfaceStyleSwitchesAutomatically = true;

      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;

      NSCloseAlwaysConfirmsChanges = false;
      NSQuitAlwaysKeepsWindows = false;
    };

    "com.apple.AppleMultitouchTrackpad" = {
      Clicking = true;
    };

    "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
      Clicking = true;
    };

    "com.apple.finder" = {
      NewWindowTarget = "PfHm";
      FXPreferredViewStyle = "clmv";
      FXDefaultSearchScope = "SCcf";

      ShowExternalHardDrivesOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
      ShowHardDrivesOnDesktop = false;
      ShowMountedServersOnDesktop = false;

      FXEnableExtensionChangeWarning = false;
      WarnOnEmptyTrash = true;

      _FXSortFoldersFirst = true;
      _FXSortFoldersFirstOnDesktop = true;
    };

    "com.apple.dock" = {
      tilesize = 48;
      autohide = false;
      magnification = false;
      mineffect = "genie";
      minimize-to-application = true;
      show-recents = false;

      showAppExposeGestureEnabled = true;
      showMissionControlGestureEnabled = true;

      wvous-br-corner = 0;

      persistent-apps = map dockApp [
        "/Applications/Helium.app"
        "/System/Applications/Messages.app"
        "/System/Applications/Music.app"
        "${config.home.homeDirectory}/Applications/Home Manager Apps/Ghostty.app"
      ];

      persistent-others = [
        {
          tile-data = {
            arrangement = 2;
            displayas = 1;
            showas = 3;
            file-data = {
              _CFURLString = "file://${config.home.homeDirectory}/Downloads/";
              _CFURLStringType = 15;
            };
          };
          tile-type = "directory-tile";
        }
      ];
    };

    "com.apple.FaceTime" = {
      FaceTimeIsAlwaysOnTop = true;
    };

    "com.apple.TelephonyUtilities" = {
      FaceTimePhotosEnabled = false;
    };

    "com.apple.iCal" = {
      "TimeZone support enabled" = true;
      WarnBeforeSendingInvitations = true;
    };

    "com.apple.Preview" = {
      PVShowImageBackground = true;
    };
  };

  targets.darwin.currentHostDefaults = {
    "com.apple.controlcenter" = {
      BatteryShowEnergyMode = true;
      BatteryShowPercentage = true;
    };
  };
}
