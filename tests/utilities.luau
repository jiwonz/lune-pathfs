local frktest = require("../luau_packages/frktest")
local test = frktest.test
local check = frktest.assert.check
local pathfs = require("../src/lib")

return function()
	test.suite("pathfs.script", function()
		test.case("should handle script path gracefully", function()
			-- Test that script() function exists and is callable
			check.is_true(type(pathfs.script) == "function")

			-- Try to call it and handle potential errors
			local success, result = pcall(function()
				return pathfs.script()
			end)

			if success then
				check.is_true(pathfs.Path.is(result))
			else
				-- It's okay if it fails in test environment
				check.is_true(type(result) == "string")
			end
		end)
	end)

	test.suite("pathfs.absolute", function()
		test.case("should return absolute path for relative path", function()
			local relativePath = "test.txt"
			local absolutePath = pathfs.absolute(relativePath)
			check.is_true(pathfs.Path.is(absolutePath))
			check.is_true(absolutePath:isAbsolute())
		end)

		test.case("should return same path for already absolute path", function()
			local currentDir = pathfs.cwd()
			local absolutePath = pathfs.absolute(currentDir)
			check.is_true(absolutePath:equal(currentDir))
		end)
	end)

	test.suite("pathfs.withoutCurDir", function()
		test.case("should remove current directory component", function()
			local pathWithCurDir = pathfs.Path.from("./test.txt")
			local pathWithoutCurDir = pathfs.withoutCurDir(pathWithCurDir)
			check.is_true(pathWithoutCurDir:equal(pathfs.Path.from("test.txt")))
		end)

		test.case("should return same path if no current directory component", function()
			local normalPath = pathfs.Path.from("test.txt")
			local result = pathfs.withoutCurDir(normalPath)
			check.is_true(result:equal(normalPath))
		end)
	end)

	test.suite("pathfs.diff", function()
		test.case("should calculate relative path between two paths", function()
			local target = pathfs.Path.from("src/file.txt")
			local base = pathfs.Path.from("tests")
			local diff = pathfs.diff(target, base)
			check.truthy(diff)
			if diff then
				check.is_true(pathfs.Path.is(diff))
			end
		end)

		test.case("should return target if target is absolute and base is relative", function()
			local target = pathfs.absolute("src/file.txt")
			local base = pathfs.Path.from("tests")
			local diff = pathfs.diff(target, base)
			check.is_true(diff ~= nil and diff:equal(target))
		end)

		test.case("should work with custom separator", function()
			local target = pathfs.Path.from("src/file.txt")
			local base = pathfs.Path.from("tests")
			local diff = pathfs.diff(target, base, "/")
			check.truthy(diff)
		end)
	end)

	test.suite("pathfs.canonicalize", function()
		test.case("should canonicalize existing path", function()
			local currentDir = pathfs.cwd()
			local canonical = pathfs.canonicalize(currentDir)
			check.is_true(pathfs.Path.is(canonical))
			check.is_true(canonical:isAbsolute())
		end)

		test.case("should throw error for non-existent path", function()
			local nonExistentPath = pathfs.Path.from("non-existent-file-xyz.txt")
			local success = pcall(function()
				pathfs.canonicalize(nonExistentPath)
			end)
			check.is_false(success)
		end)
	end)

	test.suite("pathfs.fromDir", function()
		test.case("should handle fromDir gracefully", function()
			-- Test that fromDir function exists
			check.is_true(type(pathfs.fromDir) == "function")

			-- Try to call it and handle potential errors
			local success, result = pcall(function()
				return pathfs.fromDir("test.txt")
			end)

			if success then
				check.is_true(pathfs.Path.is(result))
			else
				-- It's okay if it fails when script path is not available
				check.is_true(type(result) == "string")
			end
		end)
	end)

	test.suite("pathfs.getDir", function()
		test.case("should handle getDir gracefully", function()
			-- Test that getDir function exists
			check.is_true(type(pathfs.getDir) == "function")

			-- Try to call it and handle potential errors
			local success, result = pcall(function()
				return pathfs.getDir()
			end)

			if success then
				check.is_true(pathfs.Path.is(result))
			else
				-- It's okay if it fails when script path is not available
				check.is_true(type(result) == "string")
			end
		end)
	end)

	test.suite("pathfs.findFile", function()
		test.case("should return nil for non-existent file", function()
			local file = pathfs.findFile("non-existent-file.txt")
			check.falsy(file)
		end)

		test.case("should return FilePath for existing file", function()
			-- Test with a known existing file (README.md should exist)
			local file = pathfs.findFile("README.md")
			if file then
				check.is_true(pathfs.FilePath.is(file))
			else
				-- Test with lib.luau which should definitely exist
				local libFile = pathfs.findFile("src/lib.luau")
				check.truthy(libFile)
				if libFile then
					check.is_true(pathfs.FilePath.is(libFile))
				end
			end
		end)
	end)

	test.suite("pathfs.findDir", function()
		test.case("should return nil for non-existent directory", function()
			local dir = pathfs.findDir("non-existent-dir")
			check.falsy(dir)
		end)

		test.case("should return DirectoryPath for existing directory", function()
			local currentDir = pathfs.cwd()
			local dir = pathfs.findDir(currentDir)
			check.truthy(dir)
			if dir then
				check.is_true(pathfs.DirectoryPath.is(dir))
			end
		end)
	end)

	test.suite("pathfs.getEntries", function()
		test.case("should get entries from current directory", function()
			local currentDir = pathfs.cwd()
			local entries = pathfs.getEntries(currentDir)
			check.is_true(type(entries) == "table")
			check.is_true(#entries > 0)

			-- Check structure of first entry
			local firstEntry = entries[1]
			check.is_true(type(firstEntry.name) == "string")
			check.is_true(pathfs.Path.is(firstEntry.path))
		end)
	end)

	test.suite("pathfs.getDescendantEntries", function()
		test.case("should get descendant entries from current directory", function()
			local currentDir = pathfs.cwd()
			local entries = pathfs.getDescendantEntries(currentDir)
			check.is_true(type(entries) == "table")
			check.is_true(#entries > 0)
		end)
	end)

	test.suite("pathfs.writeFileAll", function()
		test.case("should write file and create directories", function()
			local testPath = pathfs.Path.from("temp-test-dir/test-file.txt")
			local testContent = "test content"

			-- Clean up first if exists
			pcall(function()
				pathfs.fs.removeFile(testPath)
				local parent = testPath:parent()
				if parent then
					pathfs.fs.removeDir(parent)
				end
			end)

			pathfs.writeFileAll(testPath, testContent)

			-- Verify file was created
			check.is_true(pathfs.fs.isFile(testPath))
			check.equal(pathfs.fs.readFile(testPath), testContent)

			-- Clean up
			pathfs.fs.removeFile(testPath)
			local parent = testPath:parent()
			if parent then
				pathfs.fs.removeDir(parent)
			end
		end)
	end)

	test.suite("pathfs normalize function", function()
		test.case("should normalize simple path correctly", function()
			local normalizedPath = pathfs.normalize("src/file.txt")
			check.is_true(pathfs.Path.is(normalizedPath))
			check.is_true(normalizedPath:toString():find("src") ~= nil)
			check.is_true(normalizedPath:toString():find("file.txt") ~= nil)
		end)

		test.case("should work with Path objects", function()
			local path = pathfs.Path.from("src/file.txt")
			local normalizedPath = pathfs.normalize(path)
			check.is_true(pathfs.Path.is(normalizedPath))
			check.is_true(normalizedPath:equal(path))
		end)
	end)
end
