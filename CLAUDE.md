# My Rancher

Alfredライクな自作ランチャーアプリ

## 概要

- シンプルなランチャーアプリを自作する
- Alfredのような汎用性は不要
- 後から機能を柔軟に追加できる最低限の拡張性を担保

## 技術スタック

- **Hammerspoon**: macOS自動化フレームワーク
- **Lua**: スクリプト言語（Hammerspoonのネイティブ言語）

## 設計方針

### 拡張性

- Luaスクリプトで機能の追加・更新が可能
- プラグイン形式でコマンドを追加できる構造
- 各機能は独立したモジュールとして実装

### シンプルさ

- 必要最低限の機能から始める
- 複雑な設定不要で動作する
- コードの可読性を重視

## 開発ワークフロー

### 実装時

機能追加やコード修正を行う際は **必ず** `/implement` スキルを使用すること。
このスキルは実装・テスト作成・lint・deployまで一貫して行う。

### 任意のデプロイ

デバッグ中など、任意のタイミングでデプロイしたい場合は `/deploy` を実行。

### 静的解析（luacheck）

```bash
brew install luacheck  # インストール
luacheck .             # 実行
```

**ルール:** コミット前に **必ず** luacheckを実行し、warning 0を確認すること

## プラグイン追加

`plugins/` ディレクトリにLuaファイルを追加し、`config.json` の `plugins` に登録する。

### プラグインインターフェース

```lua
local MyPlugin = {}

-- オプション: 排他的プレフィックス（このプレフィックスで始まるクエリはこのプラグインのみ処理）
MyPlugin.prefix = "my"

-- オプション: 初期化処理
function MyPlugin:init(settings)
    self.settings = settings
end

-- 必須: 候補を返す
function MyPlugin:getChoices(query, settings)
    return {
        {
            text = "Item",
            subText = "Description",
            score = 100,  -- スコアが高いほど上位に表示
        }
    }
end

-- 必須: 選択時のアクション
function MyPlugin:execute(choice, settings)
    -- 実行処理
end

return MyPlugin
```

### 登録

`config.json` の `plugins` 配列にプラグイン名を追加:

```json
"plugins": ["app_launcher", "ghq", "aws", "my_plugin"]
```

プラグイン固有の設定は `pluginSettings` に追加:

```json
"pluginSettings": {
  "my_plugin": {
    "option1": "value1"
  }
}
```
