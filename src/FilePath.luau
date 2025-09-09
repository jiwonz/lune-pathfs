local luauPath = require("../luau_packages/luau_path")
local Path = luauPath.Path
local fs = require("./fs")
local types = require("./types")

local PathType = types.PathType
local AsPathType = types.AsPathType
local ContentsType = types.ContentsType
local optionalBooleanType = types.optionalBooleanType
local stringType = types.stringType
local booleanType = types.booleanType

export type FilePath = typeof(setmetatable(
	{} :: {
		path: typeof(PathType:type()),
	},
	{} :: FilePathImpl)
)

type FilePathImpl = {
	__index: FilePathImpl,
	__tostring: (self: FilePath) -> string,
	new: (filePath: typeof(AsPathType:type())) -> FilePath,
	fromExisting: (filePath: typeof(AsPathType:type())) -> FilePath,
	withFileWritten: (
		self: FilePath,
		contents: typeof(ContentsType:type()),
		allowOverwrite: typeof(optionalBooleanType:type())
	) -> FilePath,
	is: (value: any) -> boolean,
	isFile: (self: FilePath) -> typeof(booleanType:type()),
	readFile: (self: FilePath) -> typeof(stringType:type()),
	writeFile: (self: FilePath, contents: typeof(ContentsType:type())) -> (),
	removeFile: (self: FilePath) -> (),
}

local FilePath = {} :: FilePathImpl
FilePath.__index = FilePath

function FilePath.__tostring(self)
	assert(PathType(self.path))

	return `FilePath<{self.path}>`
end

function FilePath.new(filePath)
	assert(AsPathType(filePath))

	return setmetatable({
		path = Path.from(filePath),
	}, FilePath)
end

function FilePath.fromExisting(filePath)
	assert(AsPathType(filePath))

	if not fs.isFile(filePath) then
		error(`There is no file at that path({filePath})`)
	end

	return setmetatable({
		path = Path.from(filePath),
	}, FilePath)
end

function FilePath.withFileWritten(self, contents, allowOverwrite)
	assert(ContentsType(contents))
	assert(optionalBooleanType(allowOverwrite))

	if self:isFile() then
		if allowOverwrite then
			self:removeFile()
		else
			error(`Not allowed to overwrite a file. A file already exists at that path({self.path})`)
		end
	end
	if fs.isDir(self.path) then
		error(`Cannot create a new file. The directory already exists at that path({self.path})`)
	end
	self:writeFile(contents)

	return self
end

function FilePath.is(value)
	return type(value) == "table" and getmetatable(value) == FilePath
end

function FilePath.isFile(self)
	return fs.isFile(self.path)
end

function FilePath.readFile(self)
	return fs.readFile(self.path)
end

function FilePath.writeFile(self, contents)
	return fs.writeFile(self.path, contents)
end

function FilePath.removeFile(self)
	return fs.removeFile(self.path)
end

return FilePath
