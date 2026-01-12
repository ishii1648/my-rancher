-- plugins/aws.lua
-- AWSコンソールサービス検索プラグイン

local fuzzy = require("utils.fuzzy")

local Aws = {}
Aws.__index = Aws

-- このプラグインを排他的に使用するプレフィックス
Aws.prefix = "aws"

-- デフォルトリージョン
local DEFAULT_REGION = "ap-northeast-1"

--- 初期化
--- @param settings table プラグイン設定
function Aws:init(settings)
    self.settings = settings or {}
    self.services = require("plugins.aws.services")
    self.region = settings and settings.region or DEFAULT_REGION
end

--- AWSコンソールURLを構築
--- @param service table サービス情報
--- @param region string リージョン
--- @return string URL
function Aws.buildConsoleUrl(service, region)
    if service.has_global_region then
        -- グローバルサービスはリージョンなし
        return "https://console.aws.amazon.com" .. service.url
    else
        -- リージョナルサービス
        return "https://" .. region .. ".console.aws.amazon.com" .. service.url
    end
end

--- 候補を返す
--- @param query string 検索クエリ
--- @param settings table プラグイン設定
--- @return table 候補の配列
function Aws:getChoices(query, settings)
    self.settings = settings or self.settings or {}

    -- 先頭の空白を除去
    local trimmedQuery = (query or ""):gsub("^%s+", "")

    -- "aws"で始まらない場合は候補を返さない
    if trimmedQuery == "" or not trimmedQuery:lower():match("^aws") then
        return {}
    end

    -- "aws"以降の部分を検索クエリとして使用（先頭空白除去）
    local searchQuery = trimmedQuery:sub(4):gsub("^%s+", "")

    local region = self.settings.region or DEFAULT_REGION
    local choices = {}

    for _, service in ipairs(self.services) do
        local score = 100
        local shouldAdd = true

        if searchQuery and searchQuery ~= "" then
            -- short_nameとnameの両方でマッチングを試みる
            local matchShort, scoreShort = fuzzy.match(searchQuery, service.short_name)
            local matchName, scoreName = fuzzy.match(searchQuery, service.name)
            local matchId, scoreId = fuzzy.match(searchQuery, service.id)

            if matchShort then
                score = scoreShort
            elseif matchName then
                score = scoreName
            elseif matchId then
                score = scoreId
            else
                shouldAdd = false
            end
        end

        if shouldAdd then
            local url = Aws.buildConsoleUrl(service, region)

            table.insert(choices, {
                text = service.short_name,
                subText = service.description,
                score = score,
                service = service,
                url = url,
            })
        end
    end

    return choices
end

--- 選択時のアクション
--- @param choice table 選択された候補
--- @param _settings table プラグイン設定
function Aws.execute(_self, choice, _settings)
    if not choice or not choice.url then return end

    hs.urlevent.openURL(choice.url)
end

return Aws
