.PHONY: test lint ci

# デフォルト: lint + test
all: lint test

# 静的解析
lint:
	luacheck .

# テスト実行
test:
	busted --verbose

# CI用（lint + test）
ci: lint test

# 個別テスト
test-fuzzy:
	busted spec/utils/fuzzy_spec.lua

test-plugin-loader:
	busted spec/core/plugin_loader_spec.lua
