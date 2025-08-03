vim.g.python3_host_prog = os.getenv("HOME") .. "/.pyenv/shims/python3"
require(".core")
require(".lazy")
