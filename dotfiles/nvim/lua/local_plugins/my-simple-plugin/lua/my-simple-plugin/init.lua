-- ~/.config/nvim/lua/local_plugins/my-simple-plugin/lua/my-simple-plugin/init.lua

local M = {}

-- Keep other functions if desired...

-- REVISED INTERACTIVE BUFFER FUNCTION with Autocommands
function M.show_interactive_buffer()
	-- 1. Define content parts (same as before)
	local initial_content = { "--- Received Messages ---" }
	local separator = "-----------------------"
	local input_prompt_line = "-- Type here and press <C-Enter> --"
	local initial_input = { "" }

	local initial_lines = vim.list_extend(
		vim.list_extend({}, initial_content),
		{ separator, input_prompt_line }
	)
	vim.list_extend(initial_lines, initial_input)

	-- Calculate line indices (0-based)
	local first_input_line_0based = #initial_content + 2 -- Line index AFTER the prompt

	-- 2. Create the buffer
	local bufnr = vim.api.nvim_create_buf(true, true)

	-- STORE the input line index in a buffer variable for autocommands
	vim.b[bufnr].my_plugin_first_input_line = first_input_line_0based + 1 -- Use 1-based for cursor checks

	-- 3. Set initial content
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, initial_lines)

	-- 4. Open the buffer in a split window
	local win_config = { split = 'right', width = 50 }
	local win_id = vim.api.nvim_open_win(bufnr, true, win_config)

	-- 5. Set buffer options
	vim.bo[bufnr].filetype = 'myplugin-interactive'
	vim.bo[bufnr].bufhidden = 'wipe'
	vim.bo[bufnr].swapfile = false

	-- *** START WITH MODIFIABLE OFF ***
	vim.bo[bufnr].modifiable = false

	-- 6. Define the buffer-local keymap for <C-Enter> in INSERT mode
	--    NOTE: We REMOVED the final modifiable=false and startinsert
	vim.keymap.set({ 'i', 'n' }, '<C-CR>', function() -- Also map in normal mode for convenience? Or keep 'i' only.
		local current_buf = vim.api.nvim_get_current_buf()
		if current_buf ~= bufnr then return end   -- Safety check

		-- Get lines from input section (using 1-based index from buffer var)
		local first_line_1based = vim.b[bufnr].my_plugin_first_input_line
		local input_lines = vim.api.nvim_buf_get_lines(bufnr, first_line_1based - 1, -1, false)

		local text_to_send = {}
		for _, line in ipairs(input_lines) do
			if line ~= "" then table.insert(text_to_send, line) end
		end

		if #text_to_send == 0 then
			print("Input is empty.")
			-- If in insert mode, stay there; if normal, stay there. Don't 'startinsert'.
			if vim.fn.mode() == 'i' then
				-- Optional: clear the single empty line if desired even on empty send
				-- vim.bo[bufnr].modifiable = true
				-- vim.api.nvim_buf_set_lines(bufnr, first_line_1based -1, -1, false, { "" })
				-- vim.bo[bufnr].modifiable = false -- Need careful state management if doing this
			end
			return
		end

		-- *** Temporarily make modifiable ***
		local was_modifiable = vim.bo[bufnr].modifiable -- Store current state
		vim.bo[bufnr].modifiable = true

		-- Insert captured text at the top (below line 0)
		vim.api.nvim_buf_set_lines(bufnr, 1, 1, false, text_to_send)

		-- Clear the original input lines
		-- Calculate new position of input area (1-based)
		local new_first_input_line_1based = first_line_1based + #text_to_send
		vim.b[bufnr].my_plugin_first_input_line = new_first_input_line_1based -- Update buffer variable
		vim.api.nvim_buf_set_lines(bufnr, new_first_input_line_1based - 1, -1, false, { "" })

		-- *** Restore previous modifiable state (likely true if triggered from Insert) ***
		-- OR explicitly set based on mode? Let autocommands handle it mostly.
		-- For safety during this function, let's just ensure it's true before placing cursor.
		vim.bo[bufnr].modifiable = true -- Ensure it's modifiable for cursor placement/mode check

		-- Place cursor back at the start of the input line (use 1-based for API)
		vim.api.nvim_win_set_cursor(win_id, { new_first_input_line_1based, 0 })

		-- *** DO NOT call startinsert here ***
		-- *** DO NOT set modifiable=false here ***
		-- Let the autocommands manage the state based on mode and cursor position.

		-- If we were triggered from Normal mode, enter Insert mode now AFTER changes
		if vim.fn.mode(true):find("n") then -- 'n', 'no', 'nov', etc.
			vim.cmd('startinsert')
		end
		-- If triggered from Insert mode, we just stay in Insert mode.
	end, {
		buffer = bufnr,
		noremap = true,
		silent = true,
		desc = "Send input to top section (My Simple Plugin)"
	})
	-- Consider using <C-M> instead of <C-CR> if Ctrl+Enter sends that code (check with Ctrl+V Ctrl+Enter)


	-- 7. SETUP AUTOCOMMANDS for managing 'modifiable'
	local group = vim.api.nvim_create_augroup("MySimplePluginInteractiveBuffer", { clear = true })

	local function update_modifiable()
		local current_buf = vim.api.nvim_get_current_buf()
		if current_buf ~= bufnr then return end -- Only act on our buffer

		local first_line = vim.b[bufnr].my_plugin_first_input_line
		if not first_line then return end             -- Safety check

		local cursor_pos = vim.api.nvim_win_get_cursor(0) -- Get cursor for current window {row, col}
		local cursor_line = cursor_pos[1]
		local current_mode = vim.fn.mode(true)        -- Get mode (true = include submodes like Ctrl-O)

		-- Check if cursor is in the input area (at or below the first input line)
		local in_input_area = cursor_line >= first_line

		-- Only allow modification if in insert mode AND in the input area
		if current_mode:find("^[iR]") and in_input_area then -- i, R, Ri, Rv etc.
			if not vim.bo[bufnr].modifiable then
				vim.bo[bufnr].modifiable = true
				-- print("DEBUG: Set modifiable TRUE") -- For debugging
			end
		else
			if vim.bo[bufnr].modifiable then
				vim.bo[bufnr].modifiable = false
				-- print("DEBUG: Set modifiable FALSE") -- For debugging
			end
		end
	end

	-- When leaving insert mode, always make non-modifiable
	vim.api.nvim_create_autocmd("InsertLeave", {
		group = group,
		buffer = bufnr,
		callback = function()
			if vim.bo[bufnr].modifiable then
				vim.bo[bufnr].modifiable = false
				-- print("DEBUG: InsertLeave set modifiable FALSE") -- For debugging
			end
		end,
	})

	-- When entering insert mode OR moving cursor in insert mode, check position
	vim.api.nvim_create_autocmd({ "InsertEnter", "CursorMovedI" }, {
		group = group,
		buffer = bufnr,
		callback = update_modifiable,
	})

	-- When moving cursor in normal mode, check position (optional but safer)
	vim.api.nvim_create_autocmd("CursorMoved", {
		group = group,
		buffer = bufnr,
		callback = update_modifiable,
	})

	-- 8. Initial cursor placement and mode
	vim.api.nvim_win_set_cursor(win_id, { first_input_line_0based + 1, 0 }) -- 1-based row
	-- Use schedule to ensure window/buffer is fully ready before starting insert
	vim.schedule(function()
		-- Check if buffer is still valid and current in the window
		if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_win_get_buf(win_id) == bufnr then
			vim.cmd('startinsert') -- The InsertEnter autocmd should immediately set modifiable=true
		end
	end)
end

-- Ensure setup function calls the correct interactive function
function M.setup()
	-- ... other commands/maps ...

	vim.api.nvim_create_user_command(
		'MyPluginInteractive',
		function() M.show_interactive_buffer() end,
		{ desc = 'Open interactive input buffer' }
	)
	vim.keymap.set('n', '<leader>mi', function() M.show_interactive_buffer() end,
		{ noremap = true, silent = true, desc = "Open interactive buffer (My Simple Plugin)" })

	print("My Simple Plugin setup complete (with interactive buffer + autocmds).")
end

return M
