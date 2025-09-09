local function loadTests()
	require("@tests/path")()
	require("@tests/fs")()
	require("@tests/utilities")()
end

local function runTests()
	local frktest = require("../luau_packages/frktest")

	frktest.reporters.console_reporter.init()
	local success = frktest.run()
	if not success then
		require("@lune/process").exit(1)
	end
end

loadTests()
runTests()
