### A Pluto.jl notebook ###
# v0.14.2

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 286b2de0-9a86-11eb-094d-3517eda223ee
# パッケージのインストール
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add(["Gumbo","Cascadia","GoogleTrans","PlutoUI","HTTP"])
	using Gumbo, Cascadia, GoogleTrans, PlutoUI, HTTP
end

# ╔═╡ 58743e57-0dba-45c7-bf0b-05985a678213
html"""
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<div style="
position: absolute;
width: calc(100% - 30px);
border: 50vw solid #71a13a;
border-top: 500px solid #71a13a;
border-bottom: none;
box-sizing: content-box;
left: calc(-50vw + 15px);
top: -500px;
height: 200px;
pointer-events: none;
"></div>

<div style="
height: 200px;
width: 100%;
background: #71a13a;
color: #fff;
padding-top: 68px;
">
<span style="
font-family: Vollkorn, serif;
font-weight: 700;
font-feature-settings: 'lnum', 'pnum';
"> 
<p style="text-align: center; font-size: 2rem;">
<em> PatentTranslator.jl </em>
</p>
</div>

<style>
body {
overflow-x: hidden;
}
.btn {
  background-color: DodgerBlue;
  border: none;
  color: white;
  padding: 12px 30px;
  cursor: pointer;
  font-size: 20px;
}

/* Darker background on mouse-over */
.btn:hover {
  background-color: RoyalBlue;
}
</style>"""

# ╔═╡ 912337d0-8ea1-4d34-b4ce-6f2548cd30f6
html"""
<h2 style="font-family:arial">入力</h2>
特許番号と出力言語を選んでください。"""

# ╔═╡ 0393eb50-7f63-4172-b6aa-21f6238aa08d
md"""
特許番号 : $(@bind patentnum TextField(;default="US9839852"))　出力言語 : $(@bind outputLang Select(["日本語", "英語", "中国語"]))　請求項 : $(@bind claimSelect Select(["独立項", "全請求項", "従属項"]))"""

# ╔═╡ ce5f4171-323e-43fe-a8b0-9e0458962d56
html"""
<h2 style="font-family:arial">評価</h2>
"""

# ╔═╡ 9b0ad6e4-b9b8-44ff-8027-5073d71ca61c
begin 
	evalList = ["Stupid😅", "Teribble🐯", "Great💚"]
	md"""
	評価 : $(@bind evaluation Select(evalList, default=evalList[2])) 
	
	感想 : 
	
	$(@bind impression TextField((40,8), default="この特許やばくね？")) 
	
	
	"""
end

# ╔═╡ 35eb332c-f4bf-430d-bf7f-5adb6d2e81db
html"""
<h3 style="font-family:arial">名称</h3>
"""

# ╔═╡ 23f62914-fb8f-4e42-ab3e-4b5c9aecf4fc
html"""
<h3 style="font-family:arial">請求項</h3>
"""

# ╔═╡ 95609595-40d2-4c69-8579-7d9e80bef7ee
html"""
<h3 style="font-family:arial">詳細な説明</h3>
"""

# ╔═╡ 1428ec63-fb55-48fe-9b08-825e376f3ef1
md"""
詳細な説明の翻訳表を作る場合は、下のセルのコメントアウトを外してください。
"""

# ╔═╡ 9ba5cdfa-46cf-4e99-9759-f16a5d9992c1
# HTML() do io
# 	translateDescriptions=GoogleTrans.translate.(descriptions, targetlanguage)
# 	table = "<table><tr><th>原文</th><th>翻訳</th></tr>"
# 	for (i,description) in enumerate(descriptions)
# 		table *= "<tr><td>$(description)</td><td>$(translateDescriptions[i])</td></tr>"
# 	end
# 	table *= "</table>"
# 	println(io, table)
# end

# ╔═╡ 560bed65-5997-4341-9e18-833a409ca2ad
html"""
<h3 style="font-family:arial">設定</h2>
"""

# ╔═╡ 4560a72c-60e0-4fa4-abba-4ba4148a3808
md"""
タイトル・請求項・詳細な説明を読み込むところまでのコード
"""

# ╔═╡ 4734d9ac-652b-4ea6-8916-ac1dca480d9f
begin
	lang=Dict(["英語"=>"en","中国語"=>"zh-CN","日本語"=>"ja"]);
	claim = Dict(["独立項"=>".claims .claim .claim","全請求項"=>"""div[id^="CLM"]""", "従属項"=>".claims .claim-dependent .claim"])
	patentAddress="https://patents.google.com/patent/$(patentnum)/";
	targetlanguage=lang[outputLang]
	r=HTTP.request("GET", patentAddress);
	h=parsehtml(String(r.body));
	s_title=Selector("title")
	q_title=eachmatch(s_title, h.root);
	title = q_title[1]|> nodeText
	s_claim=Selector(claim[claimSelect])
	s_desc=Selector("div.description-paragraph")
	q_claim=eachmatch(s_claim, h.root);
	q_desc=eachmatch(s_desc, h.root);
	descriptions=String[]; claims=String[]
	for q in q_claim
		push!(claims,nodeText(q))
	end
	for q in q_desc
		push!(descriptions,nodeText(q))
	end	
end;

# ╔═╡ d7054724-8626-4e02-bc22-b0f7d0369793
HTML() do io
	pdfurl = eachmatch(Selector("a"), h.root)[1].attributes["href"]
	downloadtext = """<a href=$(pdfurl)  target="_blank" rel="noopener noreferrer"><button class="btn"><i class="fa fa-download"></i> PDFをダウンロード</button></a>"""
	println(io, downloadtext)
end

# ╔═╡ bf839eaa-ded1-43ae-a384-88898b20835a
begin
	patentname=split(GoogleTrans.translate(title,"ja"), "\n")[1]
	md"""
	**$(patentname)**
	"""
end

# ╔═╡ 9050c9b3-aa38-4f82-a57b-7bfd99a090d9
begin
	hozon = "特許:"*patentname*"\n名称"*"\n評価:"*evaluation*"\n感想:"*impression
	md"""
	**メモを保存**　
	
	$(DownloadButton(hozon,patentnum*".txt"))
	"""
end

# ╔═╡ 2da4834a-e607-409c-b81f-b25001d106e3
HTML() do io
	translateClaims=GoogleTrans.translate(claims, targetlanguage)
	table = "<table><tr><th>原文</th><th>翻訳</th></tr>"
	for (i,claim) in enumerate(claims)
		table *= "<tr><td>$(claim)</td><td>$(translateClaims[i])</td></tr>"
	end
	table *= "</table>"
	println(io, table)
end

# ╔═╡ Cell order:
# ╟─58743e57-0dba-45c7-bf0b-05985a678213
# ╠═286b2de0-9a86-11eb-094d-3517eda223ee
# ╟─912337d0-8ea1-4d34-b4ce-6f2548cd30f6
# ╠═0393eb50-7f63-4172-b6aa-21f6238aa08d
# ╟─d7054724-8626-4e02-bc22-b0f7d0369793
# ╟─ce5f4171-323e-43fe-a8b0-9e0458962d56
# ╟─9b0ad6e4-b9b8-44ff-8027-5073d71ca61c
# ╟─9050c9b3-aa38-4f82-a57b-7bfd99a090d9
# ╟─35eb332c-f4bf-430d-bf7f-5adb6d2e81db
# ╟─bf839eaa-ded1-43ae-a384-88898b20835a
# ╟─23f62914-fb8f-4e42-ab3e-4b5c9aecf4fc
# ╟─2da4834a-e607-409c-b81f-b25001d106e3
# ╟─95609595-40d2-4c69-8579-7d9e80bef7ee
# ╟─1428ec63-fb55-48fe-9b08-825e376f3ef1
# ╠═9ba5cdfa-46cf-4e99-9759-f16a5d9992c1
# ╟─560bed65-5997-4341-9e18-833a409ca2ad
# ╟─4560a72c-60e0-4fa4-abba-4ba4148a3808
# ╠═4734d9ac-652b-4ea6-8916-ac1dca480d9f
