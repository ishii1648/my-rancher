-- spec/core/config_loader_spec.lua
-- config_loader.lua のテスト（buildAliasMap, resolveAlias のみ）

describe("ConfigLoader", function()
    local ConfigLoader

    setup(function()
        ConfigLoader = require("core.config_loader")
    end)

    describe("buildAliasMap()", function()
        it("aliasesが空の場合、_aliasToPluginは空テーブル", function()
            local config = { aliases = {} }
            ConfigLoader.buildAliasMap(config)

            assert.are.same({}, config._aliasToPlugin)
        end)

        it("aliasesがない場合、_aliasToPluginは空テーブル", function()
            local config = {}
            ConfigLoader.buildAliasMap(config)

            assert.are.same({}, config._aliasToPlugin)
        end)

        it("aliasesがある場合、_aliasToPluginにマッピングを構築する", function()
            local config = {
                aliases = {
                    g = "ghq",
                    a = "aws"
                }
            }
            ConfigLoader.buildAliasMap(config)

            assert.are.same({
                g = "ghq",
                a = "aws"
            }, config._aliasToPlugin)
        end)

        it("大文字のエイリアスは小文字化される", function()
            local config = {
                aliases = {
                    G = "ghq",
                    A = "aws"
                }
            }
            ConfigLoader.buildAliasMap(config)

            assert.are.same({
                g = "ghq",
                a = "aws"
            }, config._aliasToPlugin)
        end)

        it("混在した大文字小文字のエイリアスも小文字化される", function()
            local config = {
                aliases = {
                    Git = "ghq",
                    AWS = "aws"
                }
            }
            ConfigLoader.buildAliasMap(config)

            assert.are.same({
                git = "ghq",
                aws = "aws"
            }, config._aliasToPlugin)
        end)
    end)

    describe("resolveAlias()", function()
        it("存在するエイリアスを渡すと対応するプラグイン名を返す", function()
            local config = {
                _aliasToPlugin = {
                    g = "ghq",
                    a = "aws"
                }
            }

            assert.are.equal("ghq", ConfigLoader.resolveAlias("g", config))
            assert.are.equal("aws", ConfigLoader.resolveAlias("a", config))
        end)

        it("存在しないエイリアスを渡すとnilを返す", function()
            local config = {
                _aliasToPlugin = {
                    g = "ghq"
                }
            }

            assert.is_nil(ConfigLoader.resolveAlias("x", config))
        end)

        it("大文字で渡しても小文字に変換して検索される", function()
            local config = {
                _aliasToPlugin = {
                    g = "ghq",
                    aws = "aws"
                }
            }

            assert.are.equal("ghq", ConfigLoader.resolveAlias("G", config))
            assert.are.equal("aws", ConfigLoader.resolveAlias("AWS", config))
        end)

        it("_aliasToPluginが存在しない場合はnilを返す", function()
            local config = {}

            assert.is_nil(ConfigLoader.resolveAlias("g", config))
        end)

        it("_aliasToPluginがnilの場合はnilを返す", function()
            local config = { _aliasToPlugin = nil }

            assert.is_nil(ConfigLoader.resolveAlias("g", config))
        end)
    end)

    describe("buildAliasMapとresolveAliasの連携", function()
        it("buildAliasMapで構築したマップをresolveAliasで解決できる", function()
            local config = {
                aliases = {
                    g = "ghq",
                    a = "aws"
                }
            }
            ConfigLoader.buildAliasMap(config)

            assert.are.equal("ghq", ConfigLoader.resolveAlias("g", config))
            assert.are.equal("aws", ConfigLoader.resolveAlias("a", config))
        end)

        it("大文字で登録して大文字で解決できる", function()
            local config = {
                aliases = {
                    G = "ghq"
                }
            }
            ConfigLoader.buildAliasMap(config)

            assert.are.equal("ghq", ConfigLoader.resolveAlias("G", config))
            assert.are.equal("ghq", ConfigLoader.resolveAlias("g", config))
        end)
    end)
end)
