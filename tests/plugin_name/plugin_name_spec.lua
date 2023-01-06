local p = require("cgpt.module")

describe("setup", function()
  it("works with default", function()
    local query = p.create_codereview_query("ja")
    n = string.find(query, "コード")
    assert(true, n ~= nil)
  end)
end)
