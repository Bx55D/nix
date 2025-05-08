return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio"
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		vim.keymap.set('n', '<Leader>dt', dap.toggle_breakpoint, {desc="Toggle Breakpoint"})
		vim.keymap.set('n', '<Leader>dc', dap.continue, {desc="Continue"})

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		-- Debug Adapters

		dap.adapters.coreclr = {
			type = 'executable',
			command = '/usr/lib64/netcoredbg/netcoredbg',
			args = {'--interpreter=vscode'}
		}
		dap.configurations.cs = {
			{
				type = "coreclr",
				name = "launch - netcoredbg",
				request = "launch",
				program = function()
					return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
				end,
			},
		}
	end
}
