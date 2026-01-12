-- init.lua
-- Hammerspoonが最初に読み込むエントリーポイント

-- hs CLI からのリロードを有効化
require("hs.ipc")

local config = require("config")
local Launcher = require("core.launcher")

-- ランチャーインスタンスを作成
local launcher = Launcher.new(config)

-- 初期化
launcher:start()

-- リロード時のクリーンアップ
hs.shutdownCallback = function()
    launcher:stop()
end
