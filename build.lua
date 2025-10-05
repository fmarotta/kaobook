module = "kao"
-- pkgversion = "0.1.1"
-- pkgdate    = "2025-10-05"

-- directory for typeset documents
docfiledir = "./doc"
-- directory with source files
sourcefiledir = "./source"
-- source files that should be either unpacked or typeset
sourcefiles = {"*.dtx", "*.ins", "*.tex"}
-- files that should be typeset as pdf
typesetfiles = {"*.dtx", "*.tex"}
-- number of runs for typesetting (we need 3 to get the labels and notecolumns right)
typesetruns = 3

-- files whose version must be incremented
tagfiles = {"*.dtx", "*.tex"}
-- function to do the actual increment
function update_tag(file, content, tagname, tagdate)
  -- Normalize and validate inputs
  local version = tagname:match("^v") and tagname or ("v" .. tagname)

  -- Ensure version format: v1.2.3
  if not version:match("^v%d+%.%d+%.%d+$") then
    error("Invalid version format: " .. version .. " (expected v1.2.3)")
  end

  -- Ensure date format: YYYY/MM/DD
  if not tagdate:match("^%d%d%d%d/%d%d/%d%d$") then
    error("Invalid date format: " .. tagdate .. " (expected YYYY/MM/DD)")
  end

  if file:match("%.dtx$") then
    -- Example match: [2025/10/04 v0.1.0 kaobook]
    content = content:gsub(
      "%[%d%d%d%d%/%d%d%/%d%d%s+v[%d%.]+%s+kaobook%]",
      string.format("[%s %s kaobook]", tagdate, version)
    )

  elseif file:match("%.tex$") then
    -- Example matches:
    -- \date{2025/10/04}
    -- \title{Example v0.1.0}
    content = content:gsub(
      "\\date{%d%d%d%d%/%d%d%/%d%d}",
      string.format("\\date{%s}", tagdate)
    )
    content = content:gsub(
      "\\title{(.-)v[%d%.]+(.-)}",
      string.format("\\title{%s%s%s}", "%1", version, "%2")
    )
  end

  return content
end

-- number of runs for checking
checkruns = 2
-- only check with pdftex (the PDF-based comparisons are engine specific)
-- (they are also font-specific so we cannot use system fonts with luatex)
checkengines = {"pdftex"}
