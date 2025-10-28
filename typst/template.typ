// Typst helpers for the BJTU thesis template.

#let default-config = (
  two-side: false,
  blind-review: false,
  number-by-chapter: false,
)

#let font-song = ("fonts/simsun.ttc", "SimSun")
#let font-hei = ("fonts/simhei.ttf", "SimHei")
#let font-zhong = ("fonts/stzhongs.ttf", "STZhongsong")
#let font-times = "Times New Roman"

#let setup(config) = {
  #set page(
    paper: "a4",
    margin: (
      top: 3cm,
      bottom: 3cm,
      left: 2.5cm,
      right: 2.5cm,
    ),
    flipped: config.two-side,
  )

  #set text(
    font: font-song,
    fallback: (font-times, font-hei),
    size: 10.5pt,
    leading: 1.4em,
  )

  #set par(justify: true, leading: 1.4em)
  #set heading(level: 1, numbering: "1")
  #set heading(level: 2, numbering: "1.1")
  #set heading(level: 3, numbering: "1.1.1")
}

#let underline(width: 5.7cm) = {
  #box(width: width, height: 0.6pt, stroke: (paint: black, thickness: 0.6pt))
}

#let cover(metadata, config) = {
  #align(center)[
    #if config.blind-review {
      #v(2cm)
    } else {
      #image("logo/logo.png", width: 108mm)
    }
    #v(0.85cm)
    #set text(font: font-song, size: 18pt)
    *本科毕业设计（论文）*
    #v(2.25cm)
    #set text(font: font-hei, size: 18pt)
    *#metadata.title*
    #v(1em)
    #set text(font: font-song, size: 18pt)
    *#metadata.english-title*
    #v(1.6cm)
    #set text(font: font-song, size: 14pt)
    #table(columns: 2)[
      学院： & #if config.blind-review { #underline() } else { #metadata.department } \\
      专业： & #if config.blind-review { #underline() } else { #metadata.major } \\
      学生姓名： & #if config.blind-review { #underline() } else { #metadata.author } \\
      学号： & #if config.blind-review { #underline() } else { #metadata.student-number } \\
      指导教师： & #if config.blind-review { #underline() } else { #metadata.advisor }
    ]
    #v(2cm)
    #if not config.blind-review {
      #set text(font: font-song, size: 15pt)
      *北京交通大学*
      #v(1em)
    }
    #set text(font: font-song, size: 13pt)
    #metadata.year 年 #metadata.month 月
  ]
  #pagebreak()
  #set text(font: font-song, size: 10.5pt)
}

#let front-heading(title) = {
  #set text(font: font-hei, size: 16pt)
  #align(center)[*#title*]
  #v(1em)
  #set text(font: font-song, size: 10.5pt)
}

#let two-side-break(config) = {
  #pagebreak()
  #if config.two-side {
    #pagebreak()
  }
}
