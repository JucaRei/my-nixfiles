_: {
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        cat = "bat --paging=never --style=plain";
        diff = "diffr";
        glow = "glow --pager";
        #htop = "btm --basic --tree --hide_table_gap --dot_marker --mem_as_value";
        ip = "ip --color --brief";
        less = "bat --paging=always";
        more = "bat --paging=always";
        top = "btm --basic --tree --hide_table_gap --dot_marker --mem_as_value";
        tree = "exa --tree";
        wget = "wget2";

        sk = "sk --ansi -c 'grep -rI --color=always --line-number " { } " .'";

        ### Nix
        rebuild-home = "home-manager switch -b backup --flake $HOME/Zero/nix-config";
        rebuild-lock = "pushd $HOME/Zero/nix-config && nix flake lock --recreate-lock-file && popd";
        rebuild-iso-console = "pushd $HOME/Zero/nix-config && nix build .#nixosConfigurations.iso-console.config.system.build.isoImage && popd";
        rebuild-iso-desktop = "pushd $HOME/Zero/nix-config && nix build .#nixosConfigurations.iso-desktop.config.system.build.isoImage && popd";
        nix-hash-sha256 = "nix-hash --flat --base32 --type sha256";
        ### Yt-dlp
        yta-aac = "yt-dlp --extract-audio --audio-format aac ";
        yta-best = "yt-dlp --extract-audio --audio-format best --output '%(title)s.%(ext)s' --no-keep-video ";
        yta-flac = "yt-dlp --extract-audio --audio-format flac --output '%(title)s.%(ext)s' --no-keep-video ";
        yta-m4a = "yt-dlp --extract-audio --audio-format m4a --output '%(title)s.%(ext)s' --no-keep-video ";
        yta-mp3 = "yt-dlp --extract-audio --audio-format mp3 --output '%(title)s.%(ext)s' --no-keep-video ";
        yta-opus = "yt-dlp --extract-audio --audio-format opus --output '%(title)s.%(ext)s' --no-keep-video ";
        yta-vorbis = "yt-dlp --extract-audio --audio-format vorbis --output '%(title)s.%(ext)s' --no-keep-video ";
        yta-wav = "yt-dlp --extract-audio --audio-format wav --output '%(title)s.%(ext)s' --no-keep-video ";
        ytv-best = "yt-dlp -f bestvideo+bestaudio --output '%(title)s.%(ext)s' --no-keep-video ";
        ytv-best-mp4 = "yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 --no-keep-video --embed-chapters --output '%(title)s.%(ext)s' ";
        ytv-best-playlist = "yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 --no-keep-video --embed-chapters --output '%(playlist_uploader)s/%(playlist_title)s/%(title)s. [%(id)s].%(ext)s' ";
        ytv-best-playlist2 = "yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 --no-keep-video --embed-chapters --output '%(playlist_uploader)s/%(playlist_index)s/%(title)s. [%(id)s].%(ext)s' ";
        yt-plMed = "yt-dlp -f 'bestvideo[height<=720][ext=mp4]+bestaudio/best[height<=720][ext=m4a]' --merge-output-format mp4 --no-keep-video --embed-chapters --output '%(title)s.%(ext)s' ";
        yt-plHigh = "yt-dlp -f 'bestvideo[height<=1080][ext=mp4]+bestaudio/best[height<=1080][ext=m4a]' --merge-output-format mp4 --no-keep-video --embed-chapters --output '%(title)s.%(ext)s' ";
        # %(playlist_index)s
        # --parse-metadata "title:%(title)s | %(t1)s | %(t2)s | %(season)s | %(episode)s | %(t3)s" -o "MMPR_%(season)s%(episode)s_%(title)s.%(ext)s" --restrict-filenames
      };
    };
  };
}
