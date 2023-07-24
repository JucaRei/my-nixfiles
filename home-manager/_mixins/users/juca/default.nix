{ lib, hostname, username, ... }: {
  imports = [ ]
    ++ lib.optional (builtins.pathExists (./. + "/hosts/${hostname}.nix")) ./hosts/${hostname}.nix;

  home = {
    #  file.".bazaar/authentication.conf".text = "
    #    [Launchpad]
    #    host = .launchpad.net
    #    scheme = ssh
    #    user = flexiondotorg
    #  ";
    #  file.".bazaar/bazaar.conf".text = "
    #    [DEFAULT]
    #    email = juca Wimpress <code@wimpress.io>
    #    launchpad_username = flexiondotorg
    #    mail_client = default
    #    tab_width = 4
    #    [ALIASES]
    #  ";
    file.".distroboxrc".text = "\n      xhost +si:localuser:$USER\n    ";
    file.".face".source = ./face.jpg;
    #file."Development/debian/.envrc".text = "export DEB_VENDOR=Debian";
    #file."Development/ubuntu/.envrc".text = "export DEB_VENDOR=Ubuntu";
    file.".ssh/config".text = "
      Host github.com
        HostName github.com
        User git

     # Host man
     #   HostName man.wimpress.io
#
     # Host yor
     #   HostName yor.wimpress.io
#
     # Host man.ubuntu-mate.net
     #   HostName man.ubuntu-mate.net
     #   User matey
     #   IdentityFile ~/.ssh/id_rsa_semaphore
#
     # Host yor.ubuntu-mate.net
     #   HostName yor.ubuntu-mate.net
     #   User matey
     #   IdentityFile ~/.ssh/id_rsa_semaphore
#
     # Host bazaar.launchpad.net
     #   User flexiondotorg
#
     # Host git.launchpad.net
     #   User flexiondotorg
#
     # Host ubuntu.com
     #   HostName people.ubuntu.com
     #   User flexiondotorg
#
     # Host people.ubuntu.com
     #   User flexiondotorg
#
     # Host ubuntupodcast.org
     #   HostName live.ubuntupodcast.org
    ";
    file."Quickemu/nixos-console.conf".text = ''
      #!/run/current-system/sw/bin/quickemu --vm
      guest_os="linux"
      disk_img="nixos-console/disk.qcow2"
      disk_size="96G"
      iso="nixos-console/nixos.iso"
    '';
    file."Quickemu/nixos-desktop.conf".text = ''
      #!/run/current-system/sw/bin/quickemu --vm
      guest_os="linux"
      disk_img="nixos-desktop/disk.qcow2"
      disk_size="96G"
      iso="nixos-desktop/nixos.iso"
    '';
    #sessionVariables = {
    #  BZR_EMAIL = "juca Wimpress <code@wimpress.io>";
    #  DEBFULLNAME = "juca Wimpress";
    #  DEBEMAIL = "code@wimpress.io";
    #  DEBSIGN_KEYID = "8F04688C17006782143279DA61DF940515E06DA3";
    #};
  };
  programs = {
    git = {
      userEmail = "reinaldo800@gmail.com";
      userName = "Reinaldo P Jr";
      signing = {
        key = "7A53AFDE4EF7B526";
        signByDefault = true;
      };
    };
  };

  systemd.user.tmpfiles.rules = lib.mkDefault [
    "d /home/${username}/Scripts 0755 ${username} users - -"
    "d /home/${username}/Studio/OBS/config/obs-studio/ 0755 ${username} users - -"
    "d /home/${username}/Documents/workspace/linux 0755 ${username} users - -"
    "d /home/${username}/Documents/workspace/virtualmachines/windows 0755 ${username} users - -"
    "d /home/${username}/Documents/workspace/virtualmachines/linux 0755 ${username} users - -"
    "d /home/${username}/Documents/workspace/virtualmachines/mac 0755 ${username} users - -"
    "d /home/${username}/Documents/workspace/docker-configs/resources 0755 ${username} users - -"
    "d /home/${username}/Documents/workspace/docker-configs/composes 0755 ${username} users - -"
    "d /home/${username}/Documents/workspace/lab 0755 ${username} users - -"
    "d /home/${username}/Documents/workspace/github 0755 ${username} users - -"
    "d /home/${username}/Documents/workspace/bitbucket 0755 ${username} users - -"
    "d /home/${username}/Documents/workspace/gitlab 0755 ${username} users - -"
    "d /home/${username}/Documents/workspace/scripts 0755 ${username} users - -"
    "d /home/${username}/Videos/Animes/movies 0755 ${username} users - -"
    "d /home/${username}/Videos/Animes/series 0755 ${username} users - -"
    "d /home/${username}/Videos/Animes/OVAs 0755 ${username} users - -"
    "d /home/${username}/Videos/Series 0755 ${username} users - -"
    "d /home/${username}/Videos/Movies 0755 ${username} users - -"
    "d /home/${username}/Videos/Youtube 0755 ${username} users - -"
    "d /home/${username}/Videos/Youtube/Tutorials 0755 ${username} users - -"
    "d /home/${username}/Music/playlists 0755 ${username} users - -"
    "d /home/${username}/Music/albums 0755 ${username} users - -"
    "d /home/${username}/Music/singles 0755 ${username} users - -"
    "d /home/${username}/Music/artits 0755 ${username} users - -"
    "d /home/${username}/Music/downloads 0755 ${username} users - -"
    "d /home/${username}/Music/records 0755 ${username} users - -"
    "d /home/${username}/Games 0755 ${username} users - -"
    "d /home/${username}/Quickemu/nixos-desktop 0755 ${username} users - -"
    "d /home/${username}/Quickemu/nixos-console 0755 ${username} users - -"
    "d /home/${username}/Syncthing 0755 ${username} users - -"
    "d /home/${username}/Pictures/family 0755 ${username} users - -"
    "d /home/${username}/Pictures/backup 0755 ${username} users - -"
    "d /home/${username}/Pictures/phones 0755 ${username} users - -"
    "d /home/${username}/Pictures/wallpapers 0755 ${username} users - -"
    "d /home/${username}/Pictures/resources 0755 ${username} users - -"
    "d /home/${username}/Zero 0755 ${username} users - -"
    "d /home/${username}/Volatile/Vorta 0755 ${username} users - -"
    #"d /home/${username}/.config 0755 ${username} users - -"
    "L+ /home/${username}/.config/obs-studio/ - - - - /home/${username}/Studio/OBS/config/obs-studio/"
  ];
}
