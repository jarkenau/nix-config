# git.nix
{config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Julian Arkenau";
      user.email = "arkenaujulian@gmail.com";
      init.defaultBranch = "main";
      core.editor = "vim";
      fetch.prune = true;
      alias = {
        a = "add";
        ap = "add -p";
        p = "push";
        fp = "push --force-with-lease";
        st = "status";
        cv = "commit --verbose";
        cm = "commit -m";
        append = "commit --amend --no-edit";
        cp = "cherry-pick";
        sw = "switch";
        d = "diff";
        dc = "diff --cached";
        ds = "diff --stat";
        l = "log --color --graph --date=format:'%Y-%m-%d %H:%M:%S' --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'";
        last = "log -1 HEAD --stat";
        la = "!git config -l | grep alias";
        cfg = "!git config -l | grep -v '^branch'";
      };
    };
  };
}
