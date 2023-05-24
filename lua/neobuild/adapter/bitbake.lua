local bitbake = {}

bitbake.name = "neobuild-bitbake"

-- Returns a list of root pattern matches
function bitbake.root()
  return { "poky" }
end

function bitbake.configure_spec(args)
  return {
    name = bitbake.name,
    commands = {
      { command = "source", args = { "poky/oe-init-build-env" } },
    },
  }
end

function bitbake.build_spec(target)
  local args = {}

  if target ~= nil then
    table.insert(args, target)
  else
    -- TODO: How to find default target?
  end

  return {
    name = bitbake.name,
    commands = {
      { command = "bitbake", args = args },
    },
  }
end

function bitbake.clean_spec(args)
  -- TODO: Make clean, cleansstate, cleanall configurable
  args = args or { "world", "-c", "cleansstate", "--continue" }

  return {
    name = bitbake.name,
    commands = {
      { command = "bitbake", args = args },
    },
  }
end

return bitbake
