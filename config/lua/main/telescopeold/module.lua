local M = { }

local ft = function()
  local filetype = vim.bo.filetype
  if
    filetype ~= "markdown" or
    filetype ~= "txt" or
    filetype ~= ""
  then
    return {"~/notebook/cs", "~/notebook/math"}
  else
    return {"~/notebook"}
  end
end

local function grep_notes(search_dirs)
  require('telescope.builtin').live_grep({
    search_dirs = search_dirs,
    prompt_title = "Grep Notes",
    shorten_path = true
  })
end

function M.grep_notes()
  grep_notes((ft)())
end

function M.grep_notes_all()
  grep_notes({"~/notebook"})
end

function M.find_notes()
  require('telescope.builtin').find_files {
    prompt_title = 'Find Notes',
    cwd = '~/notebook',
  }
end

function M.find_home_files()
  require('telescope.builtin').find_files {
    prompt_title = 'Find Home',
    cwd = '~/',
  }
end

return M
