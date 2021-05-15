### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ a793ded7-f920-40a3-8dbf-0ab0cc9abcb4
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="PlutoUI", version="0.7"),
    ])
    using PlutoUI
end

# ╔═╡ 0dd03236-fd82-47d4-8e7e-392ff5796da7
html"""
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  
  
  <link rel="stylesheet" href="/css/franklin.css">
<link rel="stylesheet" href="/css/minimal-mistakes.css">
<link rel="stylesheet" href="/css/adjust.css">
<link rel="stylesheet" href="/css/luminous-basic.min.css">
<link rel="icon" href="/assets/favicon.ico">
<link href="https://use.fontawesome.com/releases/v5.6.1/css/all.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/earlyaccess/notosansjp.css" rel="stylesheet">
<!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"> -->

<!--[if IE ]>
<style>
  /* old IE unsupported flexbox fixes */
  .greedy-nav .site-title {
    padding-right: 3em;
  }
  .greedy-nav button {
    position: absolute;
    top: 0;
    right: 0;
    height: 100%;
  }
</style>
<![endif]-->

   <title>Julia Tips</title>  
  <!-- end custom head snippets -->
</head>
<body class="layout--single">
  <div class="masthead">
  <div class="masthead__inner-wrap">
    <div class="masthead__menu">
      <nav id="site-nav" class="greedy-nav">
        <a class="site-title" href="/">Hanafsky.com</a>
        <ul class="visible-links">
          <li class="masthead__menu-item"><a href="/tips/" >Julia-tips</a></li>
          <li class="masthead__menu-item"><a href="/blog/" >Blog</a></li>
          <li class="masthead__menu-item"><a href="/project/" >Projects</a></li>
          <li class="masthead__menu-item"><a href="/about/">About</a></li>
        </ul>
        <button class="greedy-nav__toggle hidden" type="button">
          <span class="visually-hidden">Toggle menu</span>
          <div class="navicon"></div>
        </button>
        <ul class="hidden-links hidden"></ul>
      </nav>
    </div>
  </div>
</div>

  <div class="initial-content">
    <div id="main" role="main">
      <div class="sidebar sticky">
        <div itemscope itemtype="https://schema.org/Person">
          <div class="author__avatar">
            <img src="/assets/design/author3.png" alt="Dio" itemprop="image">
          </div>
          <div class="author__content">
            <h3 class="author__name" itemprop="name">Kei Hanafusa</h3>
            <p class="author__bio" itemprop="description">Chemical Engineer, <br> living in Osaka, 🗾</p>
          </div>
          <div class="author__urls-wrapper">
            <button class="btn btn--inverse">Follow</button>
            <ul class="author__urls social-icons">
              <li itemprop="homeLocation" itemscope itemtype="https://schema.org/Place">
                <i class="fas fa-fw fa-map-marker-alt" aria-hidden="true"></i> <span itemprop="name">Osaka, Japan</span></li>
              <li><a href="https://twitter.com/hanafusakei" rel="nofollow noopener noreferrer"><i class="fab fa-fw fa-twitter-square" aria-hidden="true"></i> Twitter</a></li>
              <li><a href="https://github.com/hanafsky" rel="nofollow noopener noreferrer"><i class="fab fa-fw fa-github" aria-hidden="true"></i> GitHub</a></li>
            </ul>
          </div>

          
          
              

          <div class="author__urls-wrapper">
            <button class="btn btn--inverse">Tag</button>
            <ul class="author__urls social-icons">
              <li>タグ</li>
              <li></li>
              <li><a href="/tag/setting/">設定</a></li>
              <li><a href="/tag/thirdparty/">サードパーティライブラリ</a></li>
              <li><a href="/tag/recipe">レシピ</a></li>
            </ul>
          </div>
          
        </div>
      </div>

"""

# ╔═╡ 1e9aa8d0-b4b3-11eb-3e18-699c95790db3
md"""
# 正規表現練習帳 初級編
あるテキストから特定の表現を抜き出す、あるいは置換するには、正規表現を使うと便利です。
テキスト処理の雑用には正規表現を使うことが多いのですが、いちいちポケットリファレンスを探すのが面倒なので、自分用に練習帳を作ることにしました。
"""

# ╔═╡ b394fd31-5c72-43c0-9016-5b662b115a52
TableOfContents()

# ╔═╡ e065014c-7377-4e1b-a26d-dffb55059763
md"""
## juliaで正規表現
まずは、正規表現の書き方とjuliaで使う関数を見ていきます。

### 正規表現の書き方
あるテキストが"abc"を含んでいるかチェックしたい場合を考えます。
このとき正規表現は以下のように書けます。[^1]
```julia
r"abc"
Regex("abc")
```
ちなみにこの二通りの書き方は同じことを意味しています。

[^1]: まずは簡単な例から始めることにします。
"""

# ╔═╡ fdf57dbd-aee1-4074-a6ab-eda966225141
r"abc" == Regex("abc")

# ╔═╡ 01cfa69b-8860-4f46-903b-7f3b2597bb60
md"""
では、テキストが正規表現を含んでいるかどうか確認します。
確認には`occursin()`

"""

# ╔═╡ 79ab059c-cb19-413f-b0a8-a2e5f8bb8c6c
contains

# ╔═╡ 3a036cf4-49c7-4cf5-91f3-7c49caf7c7fe
@doc occursin

# ╔═╡ 74bf9681-2bf1-4739-b27e-ae180aa006c4
@doc Regex

# ╔═╡ 4b60d5b1-6a76-40ab-bbab-1e1166c2d5f4
@doc match

# ╔═╡ 5fd51078-16b7-4683-871e-784c5d026bb4
hint(text) = Markdown.MD(Markdown.Admonition("hint", "💡ヒント", [text]));

# ╔═╡ 38b6a075-d2f3-4aaf-ba16-bd15a0fd04c5
hint(md"""ヒントです""")

# ╔═╡ 39ae5bc5-ff86-442b-b688-a20f153b5280
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]));

# ╔═╡ 02a6c7aa-e0d4-4a4f-afde-2b077affd402
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]));

# ╔═╡ 577af230-7467-459a-9460-ab168819e18b
correct(text=md"Great! You got the right answer! Let's move on to the next section.") = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]));

# ╔═╡ Cell order:
# ╟─0dd03236-fd82-47d4-8e7e-392ff5796da7
# ╟─1e9aa8d0-b4b3-11eb-3e18-699c95790db3
# ╟─b394fd31-5c72-43c0-9016-5b662b115a52
# ╟─e065014c-7377-4e1b-a26d-dffb55059763
# ╠═fdf57dbd-aee1-4074-a6ab-eda966225141
# ╠═01cfa69b-8860-4f46-903b-7f3b2597bb60
# ╠═79ab059c-cb19-413f-b0a8-a2e5f8bb8c6c
# ╠═3a036cf4-49c7-4cf5-91f3-7c49caf7c7fe
# ╠═74bf9681-2bf1-4739-b27e-ae180aa006c4
# ╠═4b60d5b1-6a76-40ab-bbab-1e1166c2d5f4
# ╠═38b6a075-d2f3-4aaf-ba16-bd15a0fd04c5
# ╠═5fd51078-16b7-4683-871e-784c5d026bb4
# ╠═39ae5bc5-ff86-442b-b688-a20f153b5280
# ╠═02a6c7aa-e0d4-4a4f-afde-2b077affd402
# ╠═577af230-7467-459a-9460-ab168819e18b
# ╠═a793ded7-f920-40a3-8dbf-0ab0cc9abcb4
