local uv = vim.uv or vim.loop

local SOURCE_EXTS = { "ts", "tsx", "js", "jsx", "mts", "cts", "mjs", "cjs" }

local TEST_STEM_PATTERNS = {
  "^(.+)%.test%.tsx$",
  "^(.+)%.test%.ts$",
  "^(.+)%.test%.jsx$",
  "^(.+)%.test%.js$",
  "^(.+)%.spec%.tsx$",
  "^(.+)%.spec%.ts$",
  "^(.+)%.spec%.jsx$",
  "^(.+)%.spec%.js$",
  "^(.+)%.tests%.tsx$",
  "^(.+)%.tests%.ts$",
  "^(.+)%.tests%.jsx$",
  "^(.+)%.tests%.js$",
}

local function exists(path)
  return uv.fs_stat(path) ~= nil
end

local function has_tests_dir(path)
  return path:match("[/\\]__tests__[/\\]") ~= nil
end

local function test_basename_to_stem(base)
  for _, pat in ipairs(TEST_STEM_PATTERNS) do
    local stem = base:match(pat)
    if stem then
      return stem
    end
  end
  return nil
end

local function is_test_path(path)
  local base = vim.fn.fnamemodify(path, ":t")
  return test_basename_to_stem(base) ~= nil
end

local function impl_stem(path)
  return vim.fn.fnamemodify(path, ":t:r")
end

local function co_located_candidates(dir, stem)
  local out = {}
  for _, ext in ipairs({ "ts", "tsx", "js", "jsx" }) do
    table.insert(out, string.format("%s/%s.test.%s", dir, stem, ext))
    table.insert(out, string.format("%s/%s.spec.%s", dir, stem, ext))
    table.insert(out, string.format("%s/%s.tests.%s", dir, stem, ext))
  end
  return out
end

local function first_existing(list)
  for _, p in ipairs(list) do
    if exists(p) then
      return p
    end
  end
  return nil
end

local function impl_to_test(path)
  local dir = vim.fn.fnamemodify(path, ":p:h")
  local stem = impl_stem(path)
  local in_tests = has_tests_dir(path)
  local lists = {}
  if not in_tests then
    table.insert(lists, co_located_candidates(dir, stem))
    table.insert(lists, co_located_candidates(dir .. "/__tests__", stem))
  else
    table.insert(lists, co_located_candidates(dir, stem))
  end
  for _, list in ipairs(lists) do
    local found = first_existing(list)
    if found then
      return found
    end
  end
  return nil
end

local function test_to_impl(path)
  local base = vim.fn.fnamemodify(path, ":t")
  local stem = test_basename_to_stem(base)
  if not stem then
    return nil
  end
  local dir = vim.fn.fnamemodify(path, ":p:h")
  local parent
  if has_tests_dir(path) then
    parent = vim.fn.fnamemodify(dir, ":h")
  else
    parent = dir
  end
  for _, ext in ipairs(SOURCE_EXTS) do
    local p = string.format("%s/%s.%s", parent, stem, ext)
    if exists(p) then
      return p
    end
  end
  return nil
end

local function resolve(path)
  path = vim.fn.fnamemodify(path, ":p")
  if is_test_path(path) then
    return test_to_impl(path)
  end
  return impl_to_test(path)
end

local M = {}

function M.open_vsplit()
  local cur = vim.api.nvim_buf_get_name(0)
  if cur == "" then
    vim.notify("alternate test: no file", vim.log.levels.WARN)
    return
  end
  local target = resolve(cur)
  if not target then
    vim.notify("alternate test: no matching file for\n" .. cur, vim.log.levels.WARN)
    return
  end
  vim.cmd("vsplit " .. vim.fn.fnameescape(target))
end

return M
