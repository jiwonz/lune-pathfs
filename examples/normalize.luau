local pathfs = require("../src/lib")

print(pathfs.normalize("../src/./lib/../lib/normalizePath.luau"))
print(pathfs.canonicalize("./.vscode"))
