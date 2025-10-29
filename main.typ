// =======================
// Config（按需修改）
// =======================
#let cfg = (
  // 语言：中文 "zh" 或英文 "en"。将影响“图/表/Figure/Table”等本地化与标点间隔。
  lang: "zh",

  // 纸张与页边距：默认 A4 与“类 1 英寸”边距（左右略宽，常见中文论文习惯）
  paper: "a4",
  margin: (top: 2.54cm, bottom: 2.54cm, left: 3.18cm, right: 3.18cm),

  // 正文字号（10pt/11pt/12pt 常见）
  base-size: 12pt,

  // 编号策略：是否“按节编号”（LaTeX 常见的 (2.5)、图 2.3、表 2.1）
  number-by-section: true,

  // 数学公式是否只给打了 <label> 的方程编号
  number-only-labeled-equations: false, // 设为 true：仅有 label 的方程才编号
)

// =======================
// Fonts（尽量复刻 TeX 外观）
// - 西文用 "New Computer Modern"
// - 数学用 "New Computer Modern Math"
// - 中文/日文字体提供多重 fallback，自动覆盖缺字
// =======================
#set text(
  // covers: "latin-in-cjk" 能确保西文走首选西文字体，CJK 走后备 CJK 字体
  font: (
    (name: "New Computer Modern", covers: "latin-in-cjk"),
    "Noto Serif CJK SC",
    "Source Han Serif SC",
    "SimSun",
  ),
  size: cfg.base-size,
  lang: cfg.lang,
  // CJK 与拉丁之间的空隙自动处理
  cjk-latin-spacing: auto,
)

// 数学字体（OT Math）
#show math.equation: set text(font: "New Computer Modern Math")

// =======================
// 页面与文档元数据
// =======================
#set page(
  paper: cfg.paper,
  margin: cfg.margin,
  // 页面编号样式；不设置页眉页脚时，编号默认居下
  numbering: "1"
)

// PDF 元数据（不会直接打印在页面上）
#set document(
  title: [示例文章 / Sample Article],
  author: ("Your Name"),
  date: auto
)

// =======================
// 段落与排版（CJK 首段也缩进，齐行对齐）
// 0.13 起支持 first-line-indent 的结构体写法
// =======================
#set par(
  justify: true,
  spacing: 0.65em,
  first-line-indent: (amount: 2em, all: true),
)

// =======================
// 标题与目录
// =======================
#set heading(numbering: "1.") // 显示为 1、1.1、1.1.1 ...
// 目录（Table of Contents）
#let toc(title: content) = [
  = #title
  #outline(indent: auto)
]

// 文档主标题区域（近似 LaTeX \maketitle 效果）
#let maketitle(title: content, authors: array, date: auto) = [
  #title(title)
  #set block(spacing: 0.8em)
  #align(center)[
    #authors.join([ \u2003·\u2003 ])
    #if date != none { \ #date }
  ]
  #v(1.2em)
]

// =======================
// “按节编号”与计数重置逻辑
// - 图像（image）/表格（table）分轨计数，随节重置
// - 数学方程随节重置
// =======================
#let reset-counters-on(top-level: 1) = {
  #show heading.where(level: top-level): it => {
    // 每到一级标题，重置图与表、方程计数
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(math.equation).update(0)
    it
  }
}
#if cfg.number-by-section { #reset-counters-on(1) }

// 生成“节-序号”组合（用于 1.1 / 2.3 这种前缀）
// 在特定 location 取 heading 计数
#let sec-prefix-at(loc) = {
  let nums = counter(heading).at(loc).get()
  if nums.len() >= 1 { (nums.at(0),) } else { () }
}

// =======================
// 图、表题注与编号
// - 保持和 LaTeX 一致的“Figure/Table N.M: Caption”/“图N.M：标题”
// - Typst 会自动区分 image/table 两个独立计数轨道
// =======================
#show figure.caption: it => {
  // 自定义显示：补充词（Figure/图）+ 编号 + 分隔符 + 正文
  // 分隔符保持 locale 自动（英文冒号，中文全角冒号）
  [
    #it.supplement \ #context it.counter.display(
      if cfg.number-by-section { // 1.1、2.3 这样的编号
        n => numbering("1.1", ..sec-prefix-at(it.location()), n)
      } else {
        "1"
      }
    )#if it.separator != auto { [] } // separator 将在默认位置自动加入
    #it.body
  ]
}

// 若需要让“图/表”编号显示为 “节.序”：
#if cfg.number-by-section {
  // 对所有 figure 统一设置编号函数（正文处）
  #set figure(numbering: n => numbering("1.1", ..counter(heading).get().slice(0,1), n))
} else {
  #set figure(numbering: "1")
}

// =======================
// 公式编号（含按节编号 + 可选“仅 label 才编号”）
// - 解决默认在引用处取“当前节号”导致前缀错乱的问题：
//   在 ref 的 show 规则里用 locate(it.target) 回到方程位置取节号与计数
// =======================
#let eq-numbering-at(loc, n) = {
  if cfg.number-by-section {
    numbering("1.1", ..sec-prefix-at(loc), n)
  } else {
    numbering("1", n)
  }
}

// 基础：正文处的方程号码样式（加圆括号）
#set math.equation(numbering: n => [ ( #eq-numbering-at(here(), n) ) ])

// 仅给带 <label> 的方程编号（仿 LaTeX 常见习惯）
#if cfg.number-only-labeled-equations {
  #show math.equation: it => {
    if it.has("label") { math.equation(block: true, numbering: n => [ ( #eq-numbering-at(here(), n) ) ], it) }
    else { // 无 label：用同内容的“无编号”版本，并回退计数
      counter(math.equation).update(x => x - 1)
      math.equation(block: true, numbering: none, it)
    }
  }
}

// 方程引用显示为“(2.5)”并可点击跳转（而不是“式 (2.5)”等补充词）
// 关键：在引用位置用 locate(it.target) 获取方程真正的位置，避免前缀节号错位
#show ref: it => {
  if it.element != none and it.element.func() == math.equation {
    let loc = locate(it.target)
    let n = counter(math.equation).at(loc).get().at(0)
    let text = [ ( #eq-numbering-at(loc, n) ) ]
    link(loc)[#text]
  } else { it }
}

// =======================
// 定理类环境（使用 @preview/ctheorems ≥ 1.1.3）
// =======================
#import "@preview/ctheorems:1.1.3": *
#show: thmrules.with(qed-symbol: $square$)

// 与 LaTeX \newtheorem 类似的自定义
#let Theorem    = thmplain("theorem",     if cfg.lang == "zh" { "定理" } else { "Theorem"     }, base: "theorem")
#let Lemma      = thmplain("lemma",       if cfg.lang == "zh" { "引理" } else { "Lemma"       }, base: "theorem")
#let Definition = thmbox  ("definition",  if cfg.lang == "zh" { "定义" } else { "Definition"  }, base: "theorem")
#let Proof      = thmproof("proof",       if cfg.lang == "zh" { "证明" } else { "Proof"       })

// 让定理编号随节重置（和图/表/方程一致）
#if cfg.number-by-section {
  #show heading.where(level: 1): it => {
    counter(figure.where(kind: "theorem")).update(0)
    it
  }
}

// =======================
// 参考文献
// - 直接用 BibLaTeX（.bib）或 Hayagriva（.yml）均可
// - 若要 GB/T 7714，请把相应 CSL 放到项目里并用 `style: "gb-t-7714-2015"`
// =======================
#let refs() = [
  = #if cfg.lang == "zh" { [参考文献] } else { [References] }
  // 典型：BibLaTeX
  #bibliography("refs.bib", style: "ieee")
]

// =======================
// 示例正文（可删除）
// =======================
#maketitle([示例文章（与 LaTeX 版一致的版式）], ("作者甲", "作者乙"), auto)

#toc(if cfg.lang == "zh" { [目　录] } else { [Contents] })

= 引言 <sec:intro>
这是一段示例文字。CJK 首段也会缩进；中英文空隙自动调节；正文两端对齐。

== 公式与引用
带编号公式如下：
$ a^2 + b^2 = c^2 $ <eq:pythagoras>

如 @eq:pythagoras 所示，这是毕达哥拉斯定理。

== 图与表
如图 @fig:demo 与表 @tab:demo 所示。

#figure(
  image("glacier.jpg", width: 50%),
  caption: if cfg.lang == "zh" { [示例图片] } else { [Sample image] },
)<fig:demo>

#figure(
  table(
    columns: 3,
    [n], [x], [y],
    [1], [2], [3],
  ),
  caption: if cfg.lang == "zh" { [示例表格] } else { [Sample table] },
  // Typst 能自动识别“内含 table”的 figure 并切换到“表”的独立计数轨道
)<tab:demo>

= 定理环境
#Definition[
  令 $n in NN$。若存在 $a, b in ZZ$ 使 $n = a^2 + b^2$，则称 $n$ 为两个平方数之和。
]
#Theorem("Euclid")[
  质数有无穷多个。
]
#Proof[
  经典反证法略。 #qedhere
]

#refs()
