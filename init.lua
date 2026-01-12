-- init.lua
-- Hammerspoonが最初に読み込むエントリーポイント

-- hs CLI からのリロードを有効化
require("hs.ipc")

local ConfigLoader = require("core.config_loader")
local Launcher = require("core.launcher")

local config = ConfigLoader.load()

-- ランチャーインスタンスを作成
local launcher = Launcher.new(config)

-- 初期化
launcher:start()

-- リロード時のクリーンアップ
hs.shutdownCallback = function()
    launcher:stop()
end
