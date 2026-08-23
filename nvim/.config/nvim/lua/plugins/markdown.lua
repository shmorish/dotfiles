-- markdown は lint しない（整形は prettier に任せる）
--
-- lang.markdown extra は markdownlint-cli2 を linter として登録するが、
-- MD013 (行長 80) など日本語ドキュメントでは常に違反になるルールが多く、
-- 設定ファイルを別途用意しないと実用にならないためオフにする。
-- 元に戻したいときはこのファイルごと削除する。
return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = {}
      opts.linters_by_ft["markdown.mdx"] = {}
    end,
  },
}
