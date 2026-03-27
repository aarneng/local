// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
// Go ahead and customize it to your liking!
#let project(title: "", subtitle: "", authors: (), logo: "aalto", math-font: ("TeX Gyre Termes", "New Computer Modern"), body) = {
  // Set the document's basic properties.
  set document(author: authors.at(0).name, title: title)
  set page(
    numbering: "1", 
    number-align: center,
    margin: (x: 3.5cm, y: 3cm),
  )
  set text(font: "Roboto", lang: "en", hyphenate: false)

  // Title row.
  pad(
    bottom: 0em,
    align(center)[
      #block(text(weight: 700, 1.75em, title), width: 32em)
      #block(text(weight: 700, 1.15em, subtitle))
    ]
  )
  
  place(
    top + left,
    if type(logo) == str {
      if logo == "aalto" { image("aalto-logo.png", width: 13%) }
      else if logo == "hy" { image("hy-logo.png", width: 13%) }
      else { image(logo, width: 13%) }
    } else {
      logo
    },
    dx: -1em,
    dy: -1em,
  )

  // Author information.
  pad(
    top: 1em,
    bottom: 0.5em,
    x: 2em,
    grid(
      columns: (1fr,) * calc.min(3, authors.len()),
      gutter: 1em,
      ..authors.map(author => align(left, 
        block(align(center, 
          strong(author.name)
          + "\n" + author.email
        ))
      )),
    ),
  )
  line(length: 100%, stroke: 0.5pt)
  set text(font: math-font, lang: "en", hyphenate: false)
  
  show math.equation: it => {
    show sym.ast: sym.dot
    it
  }
  show heading.where(level: 1): set text(size: 1.2em)
  show heading: set text(size: 0.9em)

  set math.mat(delim: "(", column-gap: 0.7em)

  set math.equation(numbering: "(1)")
  show math.equation: it => {
    if it.block and not it.has("label") and it.numbering != none [
      #counter(math.equation).update(v => v - 1)
      #math.equation(it.body, block: true, numbering: none)
    ] else {
      it
    }
  }

  show link: set text(fill: blue)
  show link: underline
  
  show math.equation.where(block: false): box
  show math.mat: it => box(it)

  show math.equation.where(block: false): set math.frac(style: "horizontal")

  // Main body.
  // set par(justify: true)
  // show heading: it => text(
  //   weight: 560,
  //   it,
  // )

  body
}
