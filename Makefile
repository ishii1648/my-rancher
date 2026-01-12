.PHONY: test lint ci deploy help

WORKTREE ?=

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

# worktreeデプロイ
deploy:
	@if [ -z "$(WORKTREE)" ]; then \
		echo "Error: WORKTREE is required"; \
		echo "Usage: make deploy WORKTREE=<name>"; \
		exit 1; \
	fi
	@./scripts/deploy.sh $(WORKTREE)

# ヘルプ
help:
	@echo "Usage:"
	@echo "  make lint                        # luacheckを実行"
	@echo "  make test                        # テストを実行"
	@echo "  make ci                          # lint + test"
	@echo "  make deploy WORKTREE=<name>      # worktreeをデプロイ"
	@echo ""
	@echo "Available worktrees:"
	@ls -1 .worktrees/ 2>/dev/null || echo "  (none)"
