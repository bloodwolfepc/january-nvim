return {
  {
    "nvim-lilypond-suite",
    for_cat = "lilypond",
    event = "DeferredUIEnter",
    lazy = false,
    after = function()
      require("nvls").setup({
        lilypond = {
          mappings = {
            player = "<leader>s<leader>",
            compile = "<leader>sc",
            open_pdf = "<leader>sp",
            insert_verion = "<leader>sv",
            hyphenation = "<leader>shh",
            insert_hyphen = "<leader>shi",
            add_hyphen = "<leader>sha",
            del_next_hyphen = "<leader>shn",
            del_prev_hyphen = "<leader>shp",
          },
          options = {
            pitches_language = "default",
            hyphenation_language = "en_DEFAULT",
            output = "pdf",
            backend = nil,
            main_file = "main.ly",
            main_folder = "%:p:h",
            include_dir = nil,
            diagnostics = false,
            pdf_viewer = "zathura",
          }
        },
        latex = {
          mappings = {
            compile = "<leader>ec",
            open_pdf = "<leader>ep",
            lilypond_syntax = "<leader>el",
          };
          options = {
            pdf_viewer = "zathura",
          }
        },
        texinfo = {
          mappings = {
            compile = "<leader>ec",
            open_pdf = "<leader>ep",
            lilypond_syntax = "<leader>el",
          },
          options = {
            pdf_viewer = "zathura"
          }
        },
        player = {
          mappings = {
            quit = "q",
            play_pause = "p",
            loop = "<leader>sl",
            backward = "h",
            small_backward = "<S-h>",
            forward = "l",
            small_forward = "<S-l>",
            decrease_speed = "j",
            increase_speed = "k",
            halve_speed = "<S-j>",
            double_speed = "<S-k>"
          },
          options = {
            fluidsynth_flags = {
              "/home/bloodwolfe/sfz/Roland_SC-55.sf2"
            },
            midi_synth = "fluidsynth",
            audio_format = "mp3",
            mpv_flags = {
              "--volume-max=500",
              "--volume=300"
            },
          }
        },
      })

      vim.api.nvim_create_autocmd('BufEnter', {
        command = "syntax sync fromstart",
        pattern = { "*.ly", "*.ily", '*tex' }
      })
			vim.api.nvim_create_autocmd("BufWritePost", {
				group = vim.api.nvim_create_augroup("LilyPond", { clear = true }),
				pattern = { "*.ly", "*.ily" },
				callback = function()
					vim.api.nvim_command("silent LilyCmp")
				end,
			})
      vim.api.nvim_create_autocmd( 'QuickFixCmdPost', {
        command = "cwindow",
        pattern = "*"
      })
    end,
  },
  {
    "midi-input.nvim",
    for_cat = "lilypond",
    cmd = { "MidiInputStart" },
    --lazy = false,
    after = function()
    require("nvim-midi-input").setup({
      device = "Roland Digital Piano MIDI 1",
    })
    end,
  }
}
