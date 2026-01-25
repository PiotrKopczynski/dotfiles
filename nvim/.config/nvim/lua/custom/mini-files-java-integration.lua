local function create_java_class(type, dir)
  -- Prompt for class name
  vim.ui.input({ prompt = 'Enter ' .. type .. ' name: ' }, function(name)
    if not name or name == '' then
      return
    end

    local file_path = dir .. '/' .. name .. '.java'

    if vim.fn.filereadable(file_path) == 1 then
      vim.notify('File already exists!', vim.log.levels.ERROR)
      return
    end

    local package = ''
    local src_pattern = dir:match '.*src/main/java/(.*)' or dir:match '.*src/test/java/(.*)'
    if src_pattern and src_pattern ~= '' then
      package = src_pattern:gsub('/', '.')
    end

    local content = {}
    if package ~= '' then
      table.insert(content, 'package ' .. package .. ';')
      table.insert(content, '')
    end

    if type == 'Class' then
      table.insert(content, 'public class ' .. name .. ' {')
      table.insert(content, '    ')
      table.insert(content, '}')
    elseif type == 'Interface' then
      table.insert(content, 'public interface ' .. name .. ' {')
      table.insert(content, '    ')
      table.insert(content, '}')
    elseif type == 'Record' then
      table.insert(content, 'public record ' .. name .. '() {')
      table.insert(content, '    ')
      table.insert(content, '}')
    elseif type == 'Enum' then
      table.insert(content, 'public enum ' .. name .. ' {')
      table.insert(content, '    ')
      table.insert(content, '}')
    elseif type == 'Annotation' then
      table.insert(content, 'public @interface ' .. name .. ' {')
      table.insert(content, '    ')
      table.insert(content, '}')
    elseif type == 'Exception' then
      table.insert(content, 'public class ' .. name .. ' extends Exception {')
      table.insert(content, '    ')
      table.insert(content, '    public ' .. name .. '(String message) {')
      table.insert(content, '        super(message);')
      table.insert(content, '    }')
      table.insert(content, '}')
    end

    vim.fn.writefile(content, file_path)
    vim.cmd('edit ' .. file_path)
    vim.cmd('normal! ' .. (package ~= '' and '3' or '2') .. 'G$')
  end)
end

local function show_java_creation_menu()
  local MiniFiles = require 'mini.files'

  -- Capture directory info while mini.files is still open
  local fs_entry = MiniFiles.get_fs_entry()
  if not fs_entry then
    vim.notify('Could not determine current directory', vim.log.levels.ERROR)
    return
  end

  local dir = fs_entry.fs_type == 'directory' and fs_entry.path or vim.fn.fnamemodify(fs_entry.path, ':h')

  -- Close mini.files BEFORE showing the menu
  MiniFiles.close()

  -- Now show the selection menu
  local types = { 'Class', 'Interface', 'Record', 'Enum', 'Annotation', 'Exception' }
  vim.ui.select(types, {
    prompt = 'Select Java type:',
  }, function(choice)
    if choice then
      create_java_class(choice, dir)
    end
  end)
end

-- Add keymap
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferCreate',
  callback = function(args)
    local buf_id = args.data.buf_id
    vim.keymap.set('n', '<leader>jn', show_java_creation_menu, { buffer = buf_id, desc = 'Create Java class' })
  end,
})
