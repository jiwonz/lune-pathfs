<div align="center">
    <img src="https://github.com/user-attachments/assets/4fb6f4ac-fbb6-4ba1-8162-76285c5f6088" alt="Ovjo" height="100" />
</div>

<hr />

<div align="center">
	<p><a href="https://github.com/seaofvoices/luau-path">luau-path</a> + <a href="https://lune-org.github.io/docs/api-reference/fs/">@lune/fs</a> with some utilities</p>
	<a href="https://jiwonz.github.io/lune-pathfs/">View docs →</a>
</div>

## Features
- Includes typed `luau-path` utility (now fully typed)
- @lune/fs library but supports path objects (`AsPath` objects which include string and `Path` objects)
- Does not require `node` & `npm` anymore (now dependency `luau_path` is published to pesde!)
- Includes runtime type checkers via greentea.
- Features useful path and fs related utilities (such as `watchFile`, `Directory`, `diff` and more!)

## Prerequisites
- **lune**: `^0.10.2`

## Installation
Install via [pesde](https://pesde.dev/packages/jiwonz/pathfs)
```sh
pesde add jiwonz/pathfs -t lune
```

## Project Requirements
- [mise](https://github.com/jdx/mise) - Toolchain Manager
- [pesde](https://github.com/pesde-pkg/pesde) - Package Manager

## Credits
- [seaofvoices/luau-path](https://github.com/seaofvoices/luau-path) - The base of this library and cool Path implementation for Luau
- [ffrostfall/lunePackages](https://github.com/ffrostfall/lunePackages/blob/e6335a8c44957afbf1b00e3ecca37ac6a03af14d/watch/init.luau) - watch utilities base implementations

## TO-DOs
- [x] Docs
- [x] Add utils tests
- [x] Write CHANGELOG.md instead writing in README.md (maybe from v0.6.0)
- [ ] (automated via GitHub action) Release with a bundled module
