{ config, lib, pkgs, ... }:
let
  # 自作の repo をコミット固定で取ってきて、その repo の build.sh で TypeScript を Herdr が読む .js に変換する。
  # 変えたらそちらに push し、ここの rev と hash を上げる
  build = { repo, rev, hash, script }: pkgs.runCommand repo { nativeBuildInputs = [ pkgs.esbuild ]; } ''
    cd ${pkgs.fetchFromGitHub { owner = "shmorish"; inherit repo rev hash; }}
    ${script}
  '';
  # 設定・レイアウト・自作 mod
  herdrConfig = build {
    repo = "herdr-config";
    rev = "554bcdbde4efd5364b57c959c51e79ff72de0e35";
    hash = "sha256-HyAeA4GX/qRX4gMFOJINrIDQ/4wsGQhpMT9Y+1NTxmM=";
    script = ''
      sh ./build.sh $out/mods
      cp -R settings.json keys.json layouts themes $out/
    '';
  };
  # オフィスの mod。kamikuo/herdr-moe-office の fork（元の repo に LICENSE が無いので dotfiles にはコピーしない）
  herdrOffice = build {
    repo = "herdr-office";
    rev = "a3e9fd81a2ded8b0fc49d9d9d5fa8b64408cc3ba";
    hash = "sha256-G47ddGhoeTxE2Nkh4zJJFz9Jt1sXlkgzCaKfvHZmCh4=";
    script = "sh ./build.sh $out/mods/office";
  };
in
{
  # 実ファイルでコピーする（Herdr は symlink 越しの画像を読まず、store にも書けない）。
  # 同梱の layouts/mods/themes は起動時に Herdr が上書きするので、自作分だけ足す。テーマは .json だけ（LICENSE は repo に置く）。
  # 前の世代の symlink が消えてから置くので linkGeneration の後
  home.activation.herdr = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    h="${config.xdg.configHome}/herdr-app"
    run mkdir -p "$h/mods" "$h/layouts" "$h/themes"
    for src in ${herdrConfig} ${herdrOffice}; do
      for p in "$src"/mods/* "$src"/layouts/* "$src"/themes/*.json "$src"/settings.json "$src"/keys.json; do
        [ -e "$p" ] || continue
        d="$h/''${p#"$src"/}"
        run rm -rf "$d"
        run ${pkgs.coreutils}/bin/cp -R --no-preserve=mode "$p" "$d"
      done
    done
  '';
}
