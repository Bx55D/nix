-- ~/.config/nvim/lua/plugins/local-my-simple-plugin.lua

return {
	'local/my-simple-plugin',
	dir = vim.fn.stdpath('config') .. '/lua/local_plugins/my-simple-plugin',

	-- Update cmd to include the new command
	cmd = { "MyPluginHello", "MyPluginShowBuffer", "MyPluginInteractive" },

	-- Or update keys if you primarily use keymap-based loading
	-- keys = { "<leader>mh", "<leader>ms" },

	-- Or keep using lazy = false if you prefer loading on startup
	-- lazy = false,

	config = function()
		require("my-simple-plugin").setup()
	end,
}
