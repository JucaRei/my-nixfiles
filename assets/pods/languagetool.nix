{ options, config, lib, username, ... }:

with lib;
let cfg = config.modules.services.pods.languagetool;
in {
  options.modules.services.pods.languagetool = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      backend = "docker";
      containers."languagetool" = {
        autoStart = true;
        image = "erikvl87/languagetool:5.8";
        ports = [
          "8081:8010"
        ];
        volumes = [
          "/var/cache/languagetool/ngrams:/ngrams"
        ];
        environment = {
          langtool_languageModel = "/ngrams";
          # Minimal Java heap size
          Java_Xms = "256m";
          # Maximum Java heap size
          Java_Xmx = "1g";
        };
      };
    };
    systemd.services.docker-languagetool.serviceConfig = {
      User = "${username}";
      Group = "docker";
      CacheDirectory = "languagetool";
      CacheDirectoryMode = "0750";
    };
  };
}
