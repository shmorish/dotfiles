{ pkgs, ... }:
let
  # 既定の JDK。PATH と JAVA_HOME はこちら。
  jdkDefault = pkgs.temurin-bin-21;
  # 旧案件用の JDK 8 (Temurin 8 は aarch64-darwin 非対応なので Zulu)。
  # 同じプロファイルに 2 つ入れると bin/ が衝突するため、~/.jdks/ にリンクだけ置く。
  # 使うときは JAVA_HOME=~/.jdks/zulu-8 を指定する。
  jdk8 = pkgs.zulu8;
in
{
  home.packages = [ jdkDefault ];

  home.file = {
    ".jdks/temurin-21".source = jdkDefault;
    ".jdks/zulu-8".source = jdk8;
  };

  home.sessionVariables.JAVA_HOME = "${jdkDefault}";
}
