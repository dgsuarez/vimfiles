require('minuet').setup({
    -- Use the FIM (Fill-in-the-middle) provider for best ghost text performance
    provider = 'openai_fim_compatible',
    n_completions = 1,
    -- context_window = 512, -- Keeps it fast on local hardware
    provider_options = {
        openai_fim_compatible = {
            model = 'qwen2.5-coder:7b-base',
            end_point = 'http://localhost:11434/v1/completions',
            api_key = 'TERM', -- Required by the plugin, but Ollama ignores it
            name = 'Ollama',
            stream = true,
        },
    },
    virtualtext = {
        auto_trigger_ft = { '*' }, -- Enable for all file types
        keymap = {
            accept = '<Tab>',       -- This maps Tab to accept the ghost text
            accept_line = '<S-Tab>', -- Shift-Tab to accept just one line
        },
    },
})
