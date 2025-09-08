local pathfs = require("../src/lib")

local file = pathfs.FilePath.new("hi"):withFileWritten("hello")
file:writeFile("hallo")
file:removeFile()

local dir = pathfs.DirectoryPath.new("hi"):withDirWritten()
dir:removeDir()

pathfs.writeFileAll(pathfs.Path.new("a/b/c"):join(file.path), "hello2")
