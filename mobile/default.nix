{
  config,
  pkgs,
  ...
}: {
  device = "note8";
  flavor = "lineageos";
  androidVersion = 12;
  buildDateTime = 1667856426;
  ccache.enable = true;
  microg.enable = true;
  # Change variant for debugging purposes
  # variant = "eng";
  apps = {
    updater = {
      #flavor = "lineageos";
      #enable = true;
      #url = "https://android.croughan.sh";
    };
    fdroid.enable = true;
    seedvault.enable = true;
  };
  source.dirs."device/samsung/sdm710-common".patches = [
    ./system_partition_size.patch
  ];
  apps.fdroid.additionalRepos = {
    mollyim = {
      enable = true;
      url = "https://molly.im/fdroid/foss/fdroid/repo";
      pubkey = "3082053130820319a00302010202044598b6a0300d06092a864886f70d01010b050030493120301e060355040a13174d6f6c6c7920496e7374616e74204d657373656e6765723110300e060355040b1307462d44726f6964311330110603550403130a4f73636172204d697261301e170d3230313031333032353534395a170d3438303232393032353534395a30493120301e060355040a13174d6f6c6c7920496e7374616e74204d657373656e6765723110300e060355040b1307462d44726f6964311330110603550403130a4f73636172204d69726130820222300d06092a864886f70d01010105000382020f003082020a0282020100b249333b8017c58c84c6341e510637936bec51e7f36b1127b882020a2a9b8007abba407c12628b9156416f69850ebba9f1ba881d827a8874a018ac1efaac22ce9f07ee8a414df027410d6a8359b6799b764fb0e7a13339348d34f6a697dc7ff79f2e6cbfbda8213d243b265792ec6478aefd310c395494d245b6038a836d13f290ef3f3cba10d507456413294a0ad6eb9b1852605c93c00b14ba9d4c42fa7b72dbe3f492b412d39e45cf3a75a2c8bcb27c0c81cf49a626f1f0972c31967a785accc49a4992bbbaec5060659ed17a533a09071da00b37bd617f901027951d292cdc3bda63e2778ea458b3a243df3ade6e25a662bf1d0e1f8966a2bec405bab4829f954a624206ccbbbaed02556eb2fddf48238e50380be56c1ba1defc42b1ba958de355f12a35c0f4f679ffe3b0a7b027092c47c2d672dd6ab19c2cb23b58dcc3fa7a4a904d39d2ac7eac8e2e239bfd3688c2f59f9cb80f2174c0165582c1003a7ab2006df4f3216a635b30e9a2bbb062b07c81656063006fc126ffb4c8a9c64674f186dd480be8216d16e5ab2d03092166a2f64f1dbae0c564a55c9b77a157e69957454f4d4a62cc9368964679c36f0b187cb00239444210e1ec7d51d45bbfbdf96701d3df20fb51affbf891cb1bd65fd917c15a9999c56322c41c70ab2f0b821bc8977f5bc69de392e7a7977d5f2ff83282576cf7927ba2a1111d9f0c6b0f210203010001a321301f301d0603551d0e04160414d3ee008c3f0af19fa46528e17691c4cc6657b9fd300d06092a864886f70d01010b0500038202010030b9226f391f9df96fbea9fd8111b1bf3dd1b2947a6dc2044fdff7c3b7c261557d4d2e8dc398b5ed0a7bc5b666a2f894c40a4a156e4412720a6219a445aec6074bbd2378a0b82d46d245318b954d0841a4e5909c259871fcd93941fcae7b4a8f884b55bdc3a0af57caa5797fbf1e26ed625cb1e03a6b47e31d0c6afb447804f2de605facf3d0c35f4e410d3a59706a482831cf7ab72057363848919a2f854ae3279fcc246277f3493f3b88cac12bb6500d63981d2fe2126579e931b3882879a8df2404d36b415887b652402c70d5eeba627f96a1ea2e095e60e55d5d3e678516551e501eb2d675b2cc7fe9b9d3e923e411b773fb8f643855ddf1f09bae72f6d0c27925e3c245ef7bb665bb0ee531ad4fb3fec9f0f54d016e4111fecbd613c1ea4bad69a385c6c90706c6bdeaad2f08292594e951ef7a729eda3f7b8a1959b2d49fc032eab02e097b482bb85577e27a6700ac188be4581d5b0e27b4f1b22dc0c44b45e4dd2acd3934b8dd557106fc9bf0a2402ad2e72d43a090a4a4fb2ccd5fc3f0add400f91b9e22a5740cc27a1d494b651456a871dfece9aa35366f2fae1905f41c3b04dca0386889507f57c1e3eff05f30cb87e38d1d1f45c2c05815bde12f11225c22467e6ea5af04c1f3f1a0d60592c701f7ea00e809bc46f92759949a57294d13e6bad30cb31f111ace4433a634e407684282e127a67aa346487ca49b85";
    };
    bitwarden = {
      enable = true;
      url = "https://mobileapp.bitwarden.com/fdroid/repo";
      pubkey = "3082050b308202f3a003020102020450bb84bb300d06092a864886f70d01010b050030363110300e060355040b1307462d44726f6964312230200603550403131962697477617264656e2d5669727475616c2d4d616368696e65301e170d3139303630373031323531305a170d3436313032333031323531305a30363110300e060355040b1307462d44726f6964312230200603550403131962697477617264656e2d5669727475616c2d4d616368696e6530820222300d06092a864886f70d01010105000382020f003082020a02820201008d80ad2dec6a0a227fc4ccf55b20c1c968f375fadf457fd6fd03a5f0eec0743fcb037595fa450603faa94c1c49307786e591c5f4324704ed087491f6329d6921ab82402a7b2b65c14d0443e390f44e0e43af606b6aee8be0ad6fcaa808b2b68cd275844a1496e187a47a9546fed59fea48f1ee4eef6ee2b8df2d0139e6bf0dc58bd1adfcb9b6545dd0fe9ad1c685ed09692aa202745d2cbe3f43b917fdfd8fdf2ac9f01f09dd4c2a5eb3401e1648912b324c3b96dba361fc2ff7308456179ebb7fa4e6700a9af986829bb63c27ddb02c4881ec272446c3bcb286ebfcd50b1ff4e3864bc447d164400982f97c89380094e1ac146ecdf7c36469bfc6a17a177cd6f6bd14695b1858358af6a2b2f32e9ac457539ce2b19a986354483b77acbd0544863becd437ff11bb1bc9d2493b93607049c31b1cc72a81d4bfeac2eb2e49c0ab3be8037ffa2e2df90a3cf8bb2d90e37d20f917d3b56cc308fd0fa49b111daca230d77028b82285085a3c896561c8000f61b3aeb102ecf67c9466a62854bf477f82def889a6fe2d606fc296387bf70c4250188c80a292cd563a5bde28eebd7911822a01ff8667dce1324cab735b60d18f0cce3a114bb72ae0019c0f93adc1a2a8d81be9782c78d724d9917eee6b1c81a751b009f18828cf17593c1a52e27a35b03aece4f03a8dcf280557d9294d6f95df44bdeef8be32321a1397b09fb72848990203010001a321301f301d0603551d0e04160414fd6084b86a35190c8c2e14bde4ece1950c22c603300d06092a864886f70d01010b050003820201005af4595384cb93cc1be2f0afbfea9b5f7d730ed38cb15410dde9eaa1b4399229e9bef1237cb72a30978211651ba5d4c54a42815f3560fe5c6bc681b560e68cbb3783f93ce5c464900748d94a254f971bf216504c83dddf22687e1417f4b0f856054ec179ca6a40d590452eb420742238f0745e0d7aea7e2480f754d1e3d222aca89db4728b339f8f15824f6787c8f65236ec76812a3223426a24e2d86c180cf7b792f9609b1f60a3c52c1eeb976f0195ed279f30a575746e9092dcf9682f3a577b67099e2bc1f2a0315feddd2b575c94bdd60db4213f93ea6b5597c55944d3e86f73cd5c5d166d8eefdc78aea1ae66b8dfb166198fe0cfdfba348b884357f506335328432b1cae8eac5f1bd34442f30d68dbeef6b97ca1b169dc6f3c0a6d57396a09785f4a4de5853ba7a53cf92636d25a3e1d7af183b7b94b93a2aa4821aa5e9b684d1f756fde036cdc666c40fcefe65fe6be29af71440517e1f9fb3039c3394d0c3989d6f75a7675a659c568f8255080d9dcccb42f7243cf2ba1d317d432a584f095bc2ef9e394b1be16055e3a0feee66c4f0dc78854f13fbfb814ba001fa99a454dfa97684c37d71eff1959ce05b455ac3f80b960c824e2b39d985c9cf8b2d25d5c51252c547c29060b9e7e78eb53b0492f0aef0c6839c7850c95bf68038c02c5cacd6f7f43c0db065b0296ea1c313e0cec92a87edcaeb3ae4a2f51ee169d";
    };
  };
}