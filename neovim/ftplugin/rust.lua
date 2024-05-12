require("rust-tools").setup({
	server = {
		on_attach = function(_, bufnr)
			print("Attached to rust file");
		end,
	},
})
