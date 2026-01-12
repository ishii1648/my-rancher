-- spec/plugins/aws_spec.lua
-- AWS プラグインのテスト

describe("plugins/aws", function()
    describe("services.lua", function()
        local services

        setup(function()
            services = require("plugins.aws.services")
        end)

        describe("データ構造", function()
            it("空でないテーブルを返す", function()
                assert.is_table(services)
                assert.is_true(#services > 0)
            end)

            it("各サービスに必須フィールドがある", function()
                for i, service in ipairs(services) do
                    assert.is_string(service.id,
                        string.format("サービス[%d]にidがない", i))
                    assert.is_string(service.name,
                        string.format("サービス[%d]にnameがない", i))
                    assert.is_string(service.short_name,
                        string.format("サービス[%d]にshort_nameがない", i))
                    assert.is_string(service.description,
                        string.format("サービス[%d]にdescriptionがない", i))
                    assert.is_string(service.url,
                        string.format("サービス[%d]にurlがない", i))
                end
            end)

            it("urlは/で始まる", function()
                for _, service in ipairs(services) do
                    assert.is_true(
                        service.url:sub(1, 1) == "/",
                        string.format("サービス%sのurlが/で始まらない: %s",
                            service.id, service.url)
                    )
                end
            end)

            it("has_global_regionはbooleanまたはnil", function()
                for _, service in ipairs(services) do
                    if service.has_global_region ~= nil then
                        assert.is_boolean(service.has_global_region,
                            string.format("サービス%sのhas_global_regionがbooleanでない",
                                service.id))
                    end
                end
            end)
        end)

        describe("特定サービスの存在確認", function()
            local function findService(id)
                for _, service in ipairs(services) do
                    if service.id == id then
                        return service
                    end
                end
                return nil
            end

            it("EC2サービスが定義されている", function()
                local ec2 = findService("ec2")
                assert.is_not_nil(ec2)
                assert.are.equal("EC2", ec2.short_name)
                assert.are.equal("Elastic Compute Cloud", ec2.name)
            end)

            it("Lambdaサービスが定義されている", function()
                local lambda = findService("lambda")
                assert.is_not_nil(lambda)
                assert.are.equal("Lambda", lambda.short_name)
            end)

            it("グローバルサービス（IAM）が定義されている", function()
                local iam = findService("iam")
                assert.is_not_nil(iam)
                assert.is_true(iam.has_global_region)
            end)

            it("グローバルサービス（Route53）が定義されている", function()
                local route53 = findService("route53")
                assert.is_not_nil(route53)
                assert.is_true(route53.has_global_region)
            end)
        end)
    end)

    describe("aws.lua", function()
        local Aws

        setup(function()
            Aws = require("plugins.aws")
        end)

        describe("prefix", function()
            it("'aws'である", function()
                assert.are.equal("aws", Aws.prefix)
            end)
        end)

        describe("init()", function()
            it("設定を保持する", function()
                local instance = setmetatable({}, Aws)
                instance:init({ region = "us-west-2" })

                assert.are.equal("us-west-2", instance.region)
            end)

            it("設定がない場合はデフォルトリージョンを使用", function()
                local instance = setmetatable({}, Aws)
                instance:init({})

                assert.are.equal("ap-northeast-1", instance.region)
            end)

            it("servicesをロードする", function()
                local instance = setmetatable({}, Aws)
                instance:init({})

                assert.is_table(instance.services)
                assert.is_true(#instance.services > 0)
            end)
        end)

        describe("buildConsoleUrl()", function()
            it("リージョナルサービスのURLを構築する", function()
                local service = {
                    url = "/ec2/home",
                    has_global_region = false,
                }
                local url = Aws.buildConsoleUrl(service, "ap-northeast-1")

                assert.are.equal(
                    "https://ap-northeast-1.console.aws.amazon.com/ec2/home",
                    url
                )
            end)

            it("グローバルサービスのURLを構築する", function()
                local service = {
                    url = "/iam/home",
                    has_global_region = true,
                }
                local url = Aws.buildConsoleUrl(service, "ap-northeast-1")

                assert.are.equal(
                    "https://console.aws.amazon.com/iam/home",
                    url
                )
            end)

            it("異なるリージョンでURLを構築する", function()
                local service = {
                    url = "/lambda/home",
                    has_global_region = false,
                }
                local url = Aws.buildConsoleUrl(service, "us-east-1")

                assert.are.equal(
                    "https://us-east-1.console.aws.amazon.com/lambda/home",
                    url
                )
            end)

            it("has_global_regionがnilの場合はリージョナルとして扱う", function()
                local service = {
                    url = "/s3/home",
                }
                local url = Aws.buildConsoleUrl(service, "eu-west-1")

                assert.are.equal(
                    "https://eu-west-1.console.aws.amazon.com/s3/home",
                    url
                )
            end)
        end)

        describe("getChoices()", function()
            local instance

            before_each(function()
                instance = setmetatable({}, Aws)
                instance:init({})
            end)

            describe("プレフィックスの検証", function()
                it("'aws'で始まらないクエリは空を返す", function()
                    local choices = instance:getChoices("ec2", {})
                    assert.are.same({}, choices)
                end)

                it("空クエリは空を返す", function()
                    local choices = instance:getChoices("", {})
                    assert.are.same({}, choices)
                end)

                it("nilクエリは空を返す", function()
                    local choices = instance:getChoices(nil, {})
                    assert.are.same({}, choices)
                end)

                it("'aw'だけでは候補を返さない", function()
                    local choices = instance:getChoices("aw", {})
                    assert.are.same({}, choices)
                end)
            end)

            describe("awsプレフィックスでの検索", function()
                it("'aws'だけで全サービスを返す", function()
                    local choices = instance:getChoices("aws", {})
                    assert.is_true(#choices > 0)
                    assert.are.equal(#instance.services, #choices)
                end)

                it("'aws 'でも全サービスを返す", function()
                    local choices = instance:getChoices("aws ", {})
                    assert.are.equal(#instance.services, #choices)
                end)

                it("'AWS'（大文字）でも動作する", function()
                    local choices = instance:getChoices("AWS", {})
                    assert.is_true(#choices > 0)
                end)

                it("' aws'（先頭空白）でも動作する", function()
                    local choices = instance:getChoices(" aws", {})
                    assert.is_true(#choices > 0)
                end)
            end)

            describe("サービス検索", function()
                it("'aws ec2'でEC2がマッチする", function()
                    local choices = instance:getChoices("aws ec2", {})

                    local found = false
                    for _, choice in ipairs(choices) do
                        if choice.text == "EC2" then
                            found = true
                            break
                        end
                    end
                    assert.is_true(found, "EC2が見つからない")
                end)

                it("'aws lambda'でLambdaがマッチする", function()
                    local choices = instance:getChoices("aws lambda", {})

                    local found = false
                    for _, choice in ipairs(choices) do
                        if choice.text == "Lambda" then
                            found = true
                            break
                        end
                    end
                    assert.is_true(found, "Lambdaが見つからない")
                end)

                it("'aws s3'でS3がマッチする", function()
                    local choices = instance:getChoices("aws s3", {})

                    local found = false
                    for _, choice in ipairs(choices) do
                        if choice.text == "S3" then
                            found = true
                            break
                        end
                    end
                    assert.is_true(found, "S3が見つからない")
                end)

                it("'aws iam'でIAMがマッチする", function()
                    local choices = instance:getChoices("aws iam", {})

                    local found = false
                    for _, choice in ipairs(choices) do
                        if choice.text == "IAM" then
                            found = true
                            break
                        end
                    end
                    assert.is_true(found, "IAMが見つからない")
                end)

                it("存在しないサービス名は空を返す", function()
                    local choices = instance:getChoices("aws nonexistent", {})
                    assert.are.equal(0, #choices)
                end)
            end)

            describe("返却される候補の構造", function()
                it("textフィールドを持つ", function()
                    local choices = instance:getChoices("aws ec2", {})
                    assert.is_true(#choices > 0)
                    assert.is_string(choices[1].text)
                end)

                it("subTextフィールドを持つ", function()
                    local choices = instance:getChoices("aws ec2", {})
                    assert.is_true(#choices > 0)
                    assert.is_string(choices[1].subText)
                end)

                it("scoreフィールドを持つ", function()
                    local choices = instance:getChoices("aws ec2", {})
                    assert.is_true(#choices > 0)
                    assert.is_number(choices[1].score)
                end)

                it("serviceフィールドを持つ", function()
                    local choices = instance:getChoices("aws ec2", {})
                    assert.is_true(#choices > 0)
                    assert.is_table(choices[1].service)
                end)

                it("urlフィールドを持つ", function()
                    local choices = instance:getChoices("aws ec2", {})
                    assert.is_true(#choices > 0)
                    assert.is_string(choices[1].url)
                end)
            end)

            describe("URLの生成", function()
                it("リージョナルサービスは設定リージョンを使用", function()
                    local choices = instance:getChoices("aws ec2",
                        { region = "us-west-2" })

                    assert.is_true(#choices > 0, "候補が空")
                    local ec2Choice = nil
                    for _, choice in ipairs(choices) do
                        if choice.text == "EC2" then
                            ec2Choice = choice
                            break
                        end
                    end
                    assert.is_not_nil(ec2Choice, "EC2が見つからない")
                    assert.is_true(
                        ec2Choice.url:find("us%-west%-2") ~= nil,
                        "URLにリージョンが含まれない: " .. ec2Choice.url
                    )
                end)

                it("グローバルサービスはリージョンを含まない", function()
                    local choices = instance:getChoices("aws iam", {})

                    for _, choice in ipairs(choices) do
                        if choice.text == "IAM" then
                            assert.are.equal(
                                "https://console.aws.amazon.com/iam/home",
                                choice.url
                            )
                            break
                        end
                    end
                end)
            end)

            describe("ファジーマッチ", function()
                it("短縮名でマッチする", function()
                    local choices = instance:getChoices("aws ssm", {})

                    local found = false
                    for _, choice in ipairs(choices) do
                        if choice.text == "SSM" then
                            found = true
                            break
                        end
                    end
                    assert.is_true(found, "SSMが見つからない")
                end)

                it("フルネームでマッチする", function()
                    local choices = instance:getChoices("aws elastic compute", {})

                    local found = false
                    for _, choice in ipairs(choices) do
                        if choice.text == "EC2" then
                            found = true
                            break
                        end
                    end
                    assert.is_true(found, "EC2が見つからない")
                end)

                it("サービスIDでマッチする", function()
                    local choices = instance:getChoices("aws systems-manager", {})

                    local found = false
                    for _, choice in ipairs(choices) do
                        if choice.text == "SSM" then
                            found = true
                            break
                        end
                    end
                    assert.is_true(found, "SSMが見つからない")
                end)
            end)
        end)
    end)
end)
