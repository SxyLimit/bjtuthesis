#import "typst/template.typ": *

#let config = (
  two-side: false,
  blind-review: false,
  number-by-chapter: false,
)

#let metadata = (
  title: "毕业论文（设计）题目",
  english-title: "Title of Project (Thesis)",
  author: "张三",
  student-number: "100044",
  advisor: "李四",
  department: "计算机科学与技术学院",
  major: "计算机科学与技术",
  year: 2025,
  month: 6,
)

#setup(config)

#cover(metadata, config)

#if not config.blind-review {
  #include "typst/frontmatter/authorization.typ"
  #include "typst/frontmatter/originality.typ"
}

#include "typst/frontmatter/chinese-abstract.typ"
#include "typst/frontmatter/english-abstract.typ"

#two-side-break(config)
#outline(title: [目录])

#two-side-break(config)
#include "typst/chapters/introduction.typ"
#two-side-break(config)
#include "typst/chapters/relatedwork.typ"
#two-side-break(config)
#include "typst/chapters/method.typ"
#two-side-break(config)
#include "typst/chapters/experiments.typ"
#two-side-break(config)
#include "typst/chapters/conclusion.typ"

#two-side-break(config)
#front-heading("参考文献")
#bibliography("reference/ref.bib")

#if not config.blind-review {
  #two-side-break(config)
  #include "typst/frontmatter/acknowledgement.typ"
}

#two-side-break(config)
#include "typst/appendix.typ"
