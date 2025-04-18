return {
  'danymat/neogen',
  config = true,
  keys = {
      -- stylua: ignore start
      { "<leader>n", function() require("neogen").generate() end, desc = "Ge[n]erate annotation" },
  },
}
