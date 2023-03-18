local cmake = {}

cmake.name = "neobuild-cmake"

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
    }
  }
end

function cmake.build_spec(args)
  -- TODO
  return {
    name = cmake.name,
    commands = {
      { command = "cmake", args = { "--build", "build" } },
    }
  }
end

function cmake.on_failure()
  -- TODO
end

function cmake.on_success()
  -- TODO
end

return cmake
