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
    local d = dir
    for _ = 1, 32 do
      table.insert(lists, co_located_candidates(d .. "/__tests__", stem))
      local parent = vim.fn.fnamemodify(d, ":h")
      if parent == d then
        break
      end
      d = parent
    end
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

local function is_ignored_impl_path(p)
  return p:match("node_modules")
    or p:match("/%.git/")
    or p:match("/dist/")
    or p:match("/build/")
end

local function path_depth(p)
  local _, n = p:gsub("/", "/")
  return n
end

local function find_impl_under(parent, stem)
  parent = vim.fn.fnamemodify(parent, ":p")
  for _, ext in ipairs(SOURCE_EXTS) do
    local direct = string.format("%s/%s.%s", parent, stem, ext)
    if exists(direct) then
      return direct
    end
  end
  for _, ext in ipairs(SOURCE_EXTS) do
    local pat = string.format("**/%s.%s", stem, ext)
    local g = vim.fn.globpath(parent, pat, false, true)
    local matches = type(g) == "string" and (g ~= "" and { g } or {}) or g
    local candidates = {}
    for _, p in ipairs(matches) do
      p = vim.fn.fnamemodify(p, ":p")
      if not is_ignored_impl_path(p) then
        table.insert(candidates, p)
      end
    end
    table.sort(candidates, function(a, b)
      local da, db = path_depth(a), path_depth(b)
      if da ~= db then
        return da < db
      end
      return a < b
    end)
    if #candidates > 0 then
      return candidates[1]
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
  return find_impl_under(parent, stem)
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
