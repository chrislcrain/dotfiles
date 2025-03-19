return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_browser = "/Applications/Microsoft\\ Edge.app"
      vim.g.mkdp_echo_preview_url = 0
      vim.g.mkdp_theem = "dark"
      vim.g.mkdp_combine_preview = 0
    end,
    ft = { "markdown" },
  },
}
