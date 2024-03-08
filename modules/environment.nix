{ pkgs, ... }:
{
		localBinInPath = true;
		shells = with pkgs; [ fish ];
		etc."current-nixos".source = ./.;
}
