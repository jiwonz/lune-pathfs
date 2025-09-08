local luauPath = require("../luau_packages/luau_path")
local Path = luauPath.Path
local fs = require("./fs")
local types = require("./types")

local PathType = types.PathType
local AsPathType = types.AsPathType
local optionalBooleanType = types.optionalBooleanType
local arrayOfStringType = types.arrayOfStringType
local booleanType = types.booleanType

export type DirectoryPath = typeof(setmetatable(
	{} :: {
		path: typeof(PathType:type()),
	},
	{} :: DirectoryPathImpl
))

type DirectoryPathImpl = {
	__index: DirectoryPathImpl,
	__tostring: (self: DirectoryPath) -> string,
	new: (dirPath: typeof(AsPathType:type())) -> DirectoryPath,
	fromExisting: (dirPath: typeof(AsPathType:type())) -> DirectoryPath,
	withDirWritten: (self: DirectoryPath, allowOverwrite: typeof(optionalBooleanType:type())) -> DirectoryPath,
	is: (value: any) -> boolean,
	isDir: (self: DirectoryPath) -> typeof(booleanType:type()),
	readDir: (self: DirectoryPath) -> typeof(arrayOfStringType:type()),
	writeDir: (self: DirectoryPath) -> (),
	removeDir: (self: DirectoryPath) -> (),
}

local DirectoryPath = {} :: DirectoryPathImpl
DirectoryPath.__index = DirectoryPath

function DirectoryPath.__tostring(self)
	return `DirectoryPath<{self.path}>`
end

function DirectoryPath.new(dirPath)
	AsPathType:assert(dirPath)

	return setmetatable({
		path = Path.from(dirPath),
	}, DirectoryPath)
end

function DirectoryPath.fromExisting(dirPath)
	AsPathType:assert(dirPath)

	if not fs.isDir(dirPath) then
		error(`There is no directory at that path({dirPath})`)
	end

	return setmetatable({
		path = Path.from(dirPath),
	}, DirectoryPath)
end

function DirectoryPath.withDirWritten(self, allowOverwrite)
	optionalBooleanType:assert(allowOverwrite)

	if self:isDir() then
		if allowOverwrite then
			self:removeDir()
		else
			error(`Not allowed to overwrite a directory. A directory already exists at that path({self.path})`)
		end
	end
	if fs.isFile(self.path) then
		error(`Cannot write a directory. The file already exists at that path({self.path})`)
	end
	self:writeDir()

	return self
end

function DirectoryPath.is(value)
	return type(value) == "table" and getmetatable(value) == DirectoryPath
end

function DirectoryPath.isDir(self)
	local isDir = fs.isDir(self.path)

	booleanType:assert(isDir)

	return isDir
end

function DirectoryPath.readDir(self)
	return fs.readDir(self.path)
end

function DirectoryPath.writeDir(self)
	return fs.writeDir(self.path)
end

function DirectoryPath.removeDir(self)
	return fs.removeDir(self.path)
end

return DirectoryPath
