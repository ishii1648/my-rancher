-- spec/utils/fuzzy_spec.lua
-- fuzzy.lua のテスト

describe("fuzzy", function()
    local fuzzy

    setup(function()
        fuzzy = require("utils.fuzzy")
    end)

    describe("match()", function()
        describe("空クエリの場合", function()
            it("常にマッチしてスコア100を返す", function()
                local match, score = fuzzy.match("", "anything")
                assert.is_true(match)
                assert.are.equal(100, score)
            end)

            it("nilクエリでもマッチする", function()
                local match, score = fuzzy.match(nil, "anything")
                assert.is_true(match)
                assert.are.equal(100, score)
            end)
        end)

        describe("完全一致の場合", function()
            it("スコア1000を返す", function()
                local match, score = fuzzy.match("safari", "Safari")
                assert.is_true(match)
                assert.are.equal(1000, score)
            end)

            it("大文字小文字を無視する", function()
                local match, score = fuzzy.match("SAFARI", "safari")
                assert.is_true(match)
                assert.are.equal(1000, score)
            end)
        end)

        describe("前方一致の場合", function()
            it("500以上のスコアを返す", function()
                local match, score = fuzzy.match("saf", "Safari")
                assert.is_true(match)
                -- スコア = 500 + (100 - 6) = 594
                assert.are.equal(594, score)
            end)

            it("短いターゲットほど高スコア", function()
                local _, score1 = fuzzy.match("ch", "Chrome")
                local _, score2 = fuzzy.match("ch", "Chrome Browser")
                assert.is_true(score1 > score2)
            end)
        end)

        describe("部分一致の場合", function()
            it("マッチしてスコアを返す", function()
                local match, score = fuzzy.match("code", "Visual Studio Code")
                assert.is_true(match)
                -- "code" は位置15で見つかる → スコア = 300 - 15 = 285
                assert.are.equal(285, score)
            end)

            it("早い位置のマッチほど高スコア", function()
                local _, score1 = fuzzy.match("app", "Apple Store")
                local _, score2 = fuzzy.match("app", "Microsoft App")
                -- Apple: 位置1 → 299、Microsoft App: 位置11 → 289
                assert.is_true(score1 > score2)
            end)
        end)

        describe("ファジーマッチの場合", function()
            it("文字順序が一致すればマッチ", function()
                local match, score = fuzzy.match("vsc", "Visual Studio Code")
                assert.is_true(match)
                assert.is_true(score > 0)
            end)

            it("連続マッチでボーナスがつく", function()
                -- "ab"で"ab"をマッチ → 連続ボーナスあり
                local _, score1 = fuzzy.match("ab", "ab")
                -- "ab"で"a_b"をマッチ → 連続ボーナスなし
                local _, score2 = fuzzy.match("ab", "a_b")
                assert.is_true(score1 > score2)
            end)
        end)

        describe("マッチしない場合", function()
            it("falseとスコア0を返す", function()
                local match, score = fuzzy.match("xyz", "Safari")
                assert.is_false(match)
                assert.are.equal(0, score)
            end)

            it("順序が逆だとマッチしない", function()
                local match, score = fuzzy.match("cba", "abc")
                assert.is_false(match)
                assert.are.equal(0, score)
            end)
        end)

        describe("スコア優先度", function()
            it("完全一致 > 前方一致 > 部分一致 > ファジー", function()
                local _, exactScore = fuzzy.match("code", "code")
                local _, prefixScore = fuzzy.match("code", "codebase")
                local _, containsScore = fuzzy.match("code", "vscode")
                local _, fuzzyScore = fuzzy.match("cde", "code")

                assert.is_true(exactScore > prefixScore)
                assert.is_true(prefixScore > containsScore)
                assert.is_true(containsScore > fuzzyScore)
            end)
        end)
    end)
end)
