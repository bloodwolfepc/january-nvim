local kb = function()
  local mapKeys = require("utils.mapKeys")
  local cmd = function(cmd1)
    return {
      "<cmd>Gp" .. cmd1 .. "<cr>",
      cmd1
    }
  end
  local vcmd = function(cmd1)
    return {
      ":<C-u>'<,'>Gp.. cmd1 ..<cr>",
      cmd1
    }
  end

  local kb2 = {
    ["<leader>"] = {
      a = {
        c = cmd("ChatNew"),
        v = cmd("ChatToggle"),
        f = cmd("ChatFinder"),
        b = cmd("ChatNew split"),
        V = cmd("ChatNew vsplit"),
        t = cmd("ChatNew tabnew"),
      }
    }
  }
  local kb1 = {
    n = kb2,
    v = kb2,
    i = kb2
  }
  return mapKeys.lze(kb1)
end


return {
  {
    "gp.nvim",
    for_cat = "ai",
    event = "DeferredUIEnter",
    --keys = (kb)(),
    after = function()
      require("gp").setup({
        openai_api_key = os.getenv("OPENAI_API_KEY"),
        default_chat_agent = "ChatGPT4o",
      })
      require("which-key").add({
          -- VISUAL mode mappings
          -- s, x, v modes are handled the same way by which_key
          {
              mode = { "v" },
              nowait = true,
              remap = false,
              { "<leader>Ast", ":<C-u>'<,'>GpChatNew tabnew<cr>", desc = "ChatNew tabnew" },
              { "<leader>Asv", ":<C-u>'<,'>GpChatNew vsplit<cr>", desc = "ChatNew vsplit" },
              { "<leader>Ass", ":<C-u>'<,'>GpChatNew split<cr>", desc = "ChatNew split" },
              { "<leader>Aa", ":<C-u>'<,'>GpAppend<cr>", desc = "Visual Append (after)" },
              { "<leader>Ab", ":<C-u>'<,'>GpPrepend<cr>", desc = "Visual Prepend (before)" },
              { "<leader>Ac", ":<C-u>'<,'>GpChatNew<cr>", desc = "Visual Chat New" },
              { "<leader>Ag", group = "generate into new .." },
              { "<leader>Age", ":<C-u>'<,'>GpEnew<cr>", desc = "Visual GpEnew" },
              { "<leader>Agn", ":<C-u>'<,'>GpNew<cr>", desc = "Visual GpNew" },
              { "<leader>Agp", ":<C-u>'<,'>GpPopup<cr>", desc = "Visual Popup" },
              { "<leader>Agt", ":<C-u>'<,'>GpTabnew<cr>", desc = "Visual GpTabnew" },
              { "<leader>Agv", ":<C-u>'<,'>GpVnew<cr>", desc = "Visual GpVnew" },
              { "<leader>Ai", ":<C-u>'<,'>GpImplement<cr>", desc = "Implement selection" },
              { "<leader>An", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
              { "<leader>Ap", ":<C-u>'<,'>GpChatPaste<cr>", desc = "Visual Chat Paste" },
              { "<leader>Ar", ":<C-u>'<,'>GpRewrite<cr>", desc = "Visual Rewrite" },
              { "<leader>AS", "<cmd>GpStop<cr>", desc = "GpStop" },
              { "<leader>At", ":<C-u>'<,'>GpChatToggle<cr>", desc = "Visual Toggle Chat" },
              { "<leader>Aw", group = "Whisper" },
              { "<leader>Awa", ":<C-u>'<,'>GpWhisperAppend<cr>", desc = "Whisper Append" },
              { "<leader>Awb", ":<C-u>'<,'>GpWhisperPrepend<cr>", desc = "Whisper Prepend" },
              { "<leader>Awe", ":<C-u>'<,'>GpWhisperEnew<cr>", desc = "Whisper Enew" },
              { "<leader>Awn", ":<C-u>'<,'>GpWhisperNew<cr>", desc = "Whisper New" },
              { "<leader>Awp", ":<C-u>'<,'>GpWhisperPopup<cr>", desc = "Whisper Popup" },
              { "<leader>Awr", ":<C-u>'<,'>GpWhisperRewrite<cr>", desc = "Whisper Rewrite" },
              { "<leader>Awt", ":<C-u>'<,'>GpWhisperTabnew<cr>", desc = "Whisper Tabnew" },
              { "<leader>Awv", ":<C-u>'<,'>GpWhisperVnew<cr>", desc = "Whisper Vnew" },
              { "<leader>Aww", ":<C-u>'<,'>GpWhisper<cr>", desc = "Whisper" },
              { "<leader>Ax", ":<C-u>'<,'>GpContext<cr>", desc = "Visual GpContext" },
          },
          -- NORMAL mode mappings
          {
              mode = { "n" },
              nowait = true,
              remap = false,
              { "<leader>Ast", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew" },
              { "<leader>Asv", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit" },
              { "<leader>Asx", "<cmd>GpChatNew split<cr>", desc = "New Chat split" },
              { "<leader>Aa", "<cmd>GpAppend<cr>", desc = "Append (after)" },
              { "<leader>Ab", "<cmd>GpPrepend<cr>", desc = "Prepend (before)" },
              { "<leader>Ac", "<cmd>GpChatNew<cr>", desc = "New Chat" },
              { "<leader>Af", "<cmd>GpChatFinder<cr>", desc = "Chat Finder" },
              { "<leader>Ag", group = "generate into new .." },
              { "<leader>Age", "<cmd>GpEnew<cr>", desc = "GpEnew" },
              { "<leader>Agn", "<cmd>GpNew<cr>", desc = "GpNew" },
              { "<leader>Agp", "<cmd>GpPopup<cr>", desc = "Popup" },
              { "<leader>Agt", "<cmd>GpTabnew<cr>", desc = "GpTabnew" },
              { "<leader>Agv", "<cmd>GpVnew<cr>", desc = "GpVnew" },
              { "<leader>An", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
              { "<leader>Ar", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite" },
              { "<leader>AS", "<cmd>GpStop<cr>", desc = "GpStop" },
              { "<leader>At", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat" },
              { "<leader>Aw", group = "Whisper" },
              { "<leader>Awa", "<cmd>GpWhisperAppend<cr>", desc = "Whisper Append (after)" },
              { "<leader>Awb", "<cmd>GpWhisperPrepend<cr>", desc = "Whisper Prepend (before)" },
              { "<leader>Awe", "<cmd>GpWhisperEnew<cr>", desc = "Whisper Enew" },
              { "<leader>Awn", "<cmd>GpWhisperNew<cr>", desc = "Whisper New" },
              { "<leader>Awp", "<cmd>GpWhisperPopup<cr>", desc = "Whisper Popup" },
              { "<leader>Awr", "<cmd>GpWhisperRewrite<cr>", desc = "Whisper Inline Rewrite" },
              { "<leader>Awt", "<cmd>GpWhisperTabnew<cr>", desc = "Whisper Tabnew" },
              { "<leader>Awv", "<cmd>GpWhisperVnew<cr>", desc = "Whisper Vnew" },
              { "<leader>Aww", "<cmd>GpWhisper<cr>", desc = "Whisper" },
              { "<leader>Ax", "<cmd>GpContext<cr>", desc = "Toggle GpContext" },
          },
          -- INSERT mode mappings
          {
              mode = { "i" },
              nowait = true,
              remap = false,
              { "<leader>Ast>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew" },
              { "<leader>Asv", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit" },
              { "<leader>Asx", "<cmd>GpChatNew split<cr>", desc = "New Chat split" },
              { "<leader>Aa", "<cmd>GpAppend<cr>", desc = "Append (after)" },
              { "<leader>Ab", "<cmd>GpPrepend<cr>", desc = "Prepend (before)" },
              { "<leader>Ac", "<cmd>GpChatNew<cr>", desc = "New Chat" },
              { "<leader>Af", "<cmd>GpChatFinder<cr>", desc = "Chat Finder" },
              { "<leader>Ag", group = "generate into new .." },
              { "<leader>Age", "<cmd>GpEnew<cr>", desc = "GpEnew" },
              { "<leader>Agn", "<cmd>GpNew<cr>", desc = "GpNew" },
              { "<leader>Agp", "<cmd>GpPopup<cr>", desc = "Popup" },
              { "<leader>Agt", "<cmd>GpTabnew<cr>", desc = "GpTabnew" },
              { "<leader>Agv", "<cmd>GpVnew<cr>", desc = "GpVnew" },
              { "<leader>An", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
              { "<leader>Ar", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite" },
              { "<leader>AS", "<cmd>GpStop<cr>", desc = "GpStop" },
              { "<leader>At", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat" },
              { "<leader>Aw", group = "Whisper" },
              { "<leader>Awa", "<cmd>GpWhisperAppend<cr>", desc = "Whisper Append (after)" },
              { "<leader>Awb", "<cmd>GpWhisperPrepend<cr>", desc = "Whisper Prepend (before)" },
              { "<leader>Awe", "<cmd>GpWhisperEnew<cr>", desc = "Whisper Enew" },
              { "<leader>Awn", "<cmd>GpWhisperNew<cr>", desc = "Whisper New" },
              { "<leader>Awp", "<cmd>GpWhisperPopup<cr>", desc = "Whisper Popup" },
              { "<leader>Awr", "<cmd>GpWhisperRewrite<cr>", desc = "Whisper Inline Rewrite" },
              { "<leader>Awt", "<cmd>GpWhisperTabnew<cr>", desc = "Whisper Tabnew" },
              { "<leader>Awv", "<cmd>GpWhisperVnew<cr>", desc = "Whisper Vnew" },
              { "<leader>Aww", "<cmd>GpWhisper<cr>", desc = "Whisper" },
              { "<leader>Ax", "<cmd>GpContext<cr>", desc = "Toggle GpContext" },
          },
      })
    end,
  },
}

