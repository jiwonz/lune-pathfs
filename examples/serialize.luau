local pathfs = require("../src/lib")

-- Example data to serialize
local config = {
	name = "Example Application",
	version = "1.0.0",
	database = {
		host = "localhost",
		port = 5432,
		name = "myapp"
	},
	features = {
		"authentication",
		"logging",
		"caching"
	},
	settings = {
		debug = true,
		maxConnections = 100
	}
}

print("=== pathfs Serialization Example ===\n")

-- Serialize to different formats
print("1. Serializing to JSON...")
pathfs.serializeFile(config, "example-config.json")
print("   ✓ Saved to example-config.json")

print("\n2. Serializing to TOML...")
pathfs.serializeFile(config, "example-config.toml")
print("   ✓ Saved to example-config.toml")

print("\n3. Serializing to YAML...")
pathfs.serializeFile(config, "example-config.yaml")
print("   ✓ Saved to example-config.yaml")

-- Deserialize and verify
print("\n4. Deserializing JSON...")
local jsonConfig = pathfs.deserializeFile("example-config.json")
print(`   ✓ Loaded: {jsonConfig.name} v{jsonConfig.version}`)
print(`   ✓ Database: {jsonConfig.database.host}:{jsonConfig.database.port}`)

print("\n5. Deserializing TOML...")
local tomlConfig = pathfs.deserializeFile("example-config.toml")
print(`   ✓ Loaded: {tomlConfig.name} v{tomlConfig.version}`)
print(`   ✓ Features: {table.concat(tomlConfig.features, ", ")}`)

print("\n6. Deserializing YAML...")
local yamlConfig = pathfs.deserializeFile("example-config.yaml")
print(`   ✓ Loaded: {yamlConfig.name} v{yamlConfig.version}`)
print(`   ✓ Debug mode: {yamlConfig.settings.debug}`)

-- Works with Path objects too
print("\n7. Using Path objects...")
local configPath = pathfs.Path.from("path-object-config.json")
pathfs.serializeFile({ message = "Hello from Path object!" }, configPath)
local pathObjectConfig = pathfs.deserializeFile(configPath)
print(`   ✓ Message: {pathObjectConfig.message}`)

-- Clean up example files
print("\n8. Cleaning up...")
pathfs.fs.removeFile("example-config.json")
pathfs.fs.removeFile("example-config.toml")
pathfs.fs.removeFile("example-config.yaml")
pathfs.fs.removeFile("path-object-config.json")
print("   ✓ Cleaned up example files")

print("\n=== Example completed successfully! ===")
