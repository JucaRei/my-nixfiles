{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "[]"
        "(fg:dark-blue)"
        "$username"
        "$hostname"
        "[]"
        "(fg:dark-blue bg:light-blue)"
        "$directory"
        "[]"
        "(fg:light-blue bg:purple)"
        "$git_branch"
        "$git_status"
        "[]"
        "(fg:purple bg:dark-blue)"
        "$rust"
        "[]"
        "(fg:dark-blue)"
        "$fill"
        "[]"
        "(fg:dark-blue)"
        "$cmd_duration"
        "[]"
        "(fg:purple bg:dark-blue)"
        "$jobs"
        "[]"
        "(fg:light-blue bg:purple)"
        "$status"
        "[]"
        "(fg:dark-blue bg:light-blue)"
        "$localip"
        "[]"
        "(fg:dark-blue)"
        "$line_break"
        "$character"
      ];

      aws.symbol = mkDefault " ";
      battery.full_symbol = mkDefault "";
      battery.charging_symbol = mkDefault "";
      battery.discharging_symbol = mkDefault "";
      battery.unknown_symbol = mkDefault "";
      battery.empty_symbol = mkDefault "";
      cmake.symbol = mkDefault "△ ";
      conda.symbol = mkDefault " ";
      crystal.symbol = mkDefault " ";
      dart.symbol = mkDefault " ";
      #directory.read_only = mkDefault " ";
      docker_context.symbol = mkDefault " ";
      dotnet.symbol = mkDefault " ";
      elixir.symbol = mkDefault " ";
      elm.symbol = mkDefault " ";
      erlang.symbol = mkDefault " ";
      gcloud.symbol = mkDefault " ";
      #git_branch.symbol = mkDefault " ";
      git_commit.tag_symbol = mkDefault " ";
      #git_status.format = mkDefault "([$all_status$ahead_behind]($style) )";
      #git_status.conflicted = mkDefault " ";
      #git_status.ahead = mkDefault " ";
      #git_status.behind = mkDefault " ";
      #git_status.diverged = mkDefault " ";
      #git_status.untracked = mkDefault " ";
      #git_status.stashed = mkDefault " ";
      #git_status.modified = mkDefault " ";
      #git_status.staged = mkDefault " ";
      #git_status.renamed = mkDefault " ";
      #git_status.deleted = mkDefault " ";
      golang.symbol = mkDefault " ";
      helm.symbol = mkDefault "⎈ ";
      hg_branch.symbol = mkDefault " ";
      java.symbol = mkDefault " ";
      julia.symbol = mkDefault " ";
      kotlin.symbol = mkDefault " ";
      kubernetes.symbol = mkDefault "☸ ";
      lua.symbol = mkDefault " ";
      memory_usage.symbol = mkDefault " ";
      nim.symbol = mkDefault " ";
      nix_shell.symbol = mkDefault " ";
      nodejs.symbol = mkDefault " ";
      openstack.symbol = mkDefault " ";
      package.symbol = mkDefault " ";
      perl.symbol = mkDefault " ";
      php.symbol = mkDefault " ";
      purescript.symbol = mkDefault "<≡> ";
      python.symbol = mkDefault " ";
      ruby.symbol = mkDefault " ";
      shlvl.symbol = mkDefault " ";
      swift.symbol = mkDefault " ";
      terraform.symbol = mkDefault "𝗧 ";
      vagrant.symbol = mkDefault "𝗩 ";
      zig.symbol = mkDefault " ";

      # Bottom right only
      right_format = lib.concatStrings [
        "[](fg:purple)"
        "$memory_usage"
        "[](fg:pink bg:purple)"
        "$time"
        "[](fg:pink)"
      ];

      palette = "cyberpunk-neon";

      palettes.cyberpunk-neon = {
        dark-blue = "17";
        # blue =
        light-blue = "25";
        cyan = "44";
        pink = "201";
        purple = "13";
        red = "9";
        #orange = "208";
        white = "255";
        #yellow = "11";
        green = "#00FF00";
      };

      # Upper left
      username = {
        show_always = true;
        style_user = "fg:pink bg:dark-blue";
        style_root = "fg:red bg:dark-blue";
        format = "[ $user]($style)[@]($style)";
      };

      hostname = {
        ssh_only = false;
        style = "fg:pink bg:dark-blue";
        format = "[$hostname ]($style)";
      };

      directory = {
        style = "fg:cyan bg:light-blue";
        read_only = "";
        read_only_style = "fg:cyan bg:light-blue";
        format = "[  $path]($style)[$read_only ]($read_only_style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      # Here is how you can shorten some long paths by text replacement
      directory.substitutions = {
        "Documents" = " ";
        "Downloads" = " ";
        "Music" = " ";
        "Pictures" = " ";
      };
      # Keep in mind that the order matters. For example:
      # "Important Documents" = "  "
      # will not be replaced, because "Documents" was already substituted before.
      # So either put "Important Documents" before "Documents" or use the substituted version:
      # "Important  " = " 
      git_branch = {
        symbol = "";
        style = "fg:green bg:purple";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        conflicted = "=$count";
        ahead = "⇡$count";
        behind = "⇣$count";
        diverged = "⇕⇣$behind_count⇡$ahead_count";
        untracked = "?$count";
        stashed = " $count";
        modified = "!$count";
        staged = "+$count";
        renamed = "»$count";
        deleted = "✘$count";
        style = "fg:green bg:purple";
        format = "[($all_status$ahead_behind )]($style)";
      };

      rust = {
        symbol = "";
        style = "fg:pink bg:dark-blue";
        format = "[ $symbol ($version) ]($style)";
      };

      fill.symbol = " ";

      # Upper right
      cmd_duration = {
        min_time = 10000;
        style = "bold fg:pink bg:dark-blue";
        format = "[ $duration  ]($style)";
        show_milliseconds = true;
      };

      jobs = {
        style = "bold fg:cyan bg:purple";
        symbol = "";
        format = "[ $number$symbol ]($style)";
      };

      status = {
        disabled = false;
        style = "bold fg:cyan bg:light-blue";
        symbol = "✘";
        not_executable_symbol = "";
        not_found_symbol = "";
        sigint_symbol = "";
        signal_symbol = "";
        map_symbol = true;
        format = "[ $common_meaning $status $symbol ]($style)";
      };

      localip = {
        disabled = false;
        ssh_only = false;
        style = "fg:pink bg:dark-blue";
        format = "[ $localipv4 ﯱ ]($style)";
      };

      # Lower left
      character = {
        success_symbol = "[❯](bold fg:cyan)";
        error_symbol = "[❯](bold fg:pink)";
        vicmd_symbol = "[❮](bold fg:cyan)";
      };

      # Lower right
      memory_usage = {
        disabled = false;
        threshold = 0;
        #symbol = "";
        style = "fg:cyan bg:purple";
        format = "[ $ram_pct $swap_pct $symbol ]($style)";
      };

      time = {
        disabled = false;
        time_format = "%T"; # Hour:Minute:Second Format
        style = "fg:white bg:pink";
        format = "[ $time  ]($style)";
      };
    };
  };
}
