local cmake = {}

cmake.name = "neobuild-cmake"

cmake.config = {
  generator = "ninja",
  source_dir = vim.loop.cwd(),
  build_dir = "build",
  build_type = "Debug", -- RelWithDebInfo
}

-- Returns a list of root pattern matches
function cmake.root()
  return { "CMakeLists.txt" }
end

function cmake.configure_spec(args)
  -- TODO
  return {
    name = cmake.name,
    commands = {
      { command = "cmake", args = { "-S", ".", "-B", "build" } },
    },
  }
end

function cmake.build_spec(target)
  local args = { "--build", "build" }

  if target ~= nil then
    table.insert(args, "--target")
    table.insert(args, target .. ".o")
  end

  return {
    name = cmake.name,
    commands = {
      { command = "cmake", args = args },
    },
  }
end

function cmake.clean_spec(args)
  return {
    name = cmake.name,
    commands = {
      { command = "cmake", args = { "--build", "build", "--target", "clean" } },
    },
  }
end

return cmake
