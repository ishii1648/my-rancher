-- core/config_loader.lua
-- 設定ファイルのローダー（JSON優先、Luaフォールバック）

local ConfigLoader = {}

--- 設定ファイルを読み込む
--- config.json が存在すればJSONを読み込み、なければ config.lua にフォールバック
--- @return table 設定テーブル
function ConfigLoader.load()
    local configPath = hs.configdir .. "/config.json"
    local config = nil

    -- JSON設定を優先
    local attr = hs.fs.attributes(configPath)
    if attr and attr.mode == "file" then
        config = hs.json.read(configPath)
        if config then
            hs.printf("[ConfigLoader] Loaded config from config.json")
        else
            hs.printf("[ConfigLoader] Failed to parse config.json, falling back to config.lua")
        end
    end

    -- フォールバック
    if not config then
        config = require("config")
        hs.printf("[ConfigLoader] Loaded config from config.lua")
    end

    -- エイリアスマップを構築
    ConfigLoader.buildAliasMap(config)

    return config
end

--- エイリアスマップを構築
--- @param config table 設定テーブル
function ConfigLoader.buildAliasMap(config)
    config._aliasToPlugin = {}

    if config.aliases then
        for alias, pluginName in pairs(config.aliases) do
            config._aliasToPlugin[alias:lower()] = pluginName
        end
    end
end

--- エイリアスからプラグイン名を解決
--- @param alias string エイリアス
--- @param config table 設定テーブル
--- @return string|nil プラグイン名（見つからなければnil）
function ConfigLoader.resolveAlias(alias, config)
    if not config._aliasToPlugin then
        return nil
    end
    return config._aliasToPlugin[alias:lower()]
end

return ConfigLoader
