# https://github.com/thexyno/nixos-config/blob/main/data/pubkeys.nix
let
  alex =
    let
      user = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII+F3XpAIh4l8GfPgwoTqWQj0OdZRnnG9Ak4Z0wu0Upj" #slartibartfast
      ];
    in
    {
      # inherit user server client;
      # computers = user ++ (builtins.foldl' (a: b: a ++ b) [ ] (builtins.attrValues hosts)); # everything
      # host = hn: (hosts.${hn} ++ user);
      # hosts = hn: ((map (x: hosts.${x}) hn) ++ user);
      inherit user;
    };
in
{
  inherit alex;
}