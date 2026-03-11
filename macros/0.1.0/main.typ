#let make-title(exnum: none, titledesc: "Exercise", cnt) = {
  let mycounter = counter(titledesc)

  if (exnum == none) {
    mycounter.step()
  } else {
    mycounter.update(exnum)
  }

  context heading[#titledesc #mycounter.display()]

  text(style: "italic", size: 0.9em)[#cnt]
}


#let dollarArrow = {
  /*
  define a function to draw
  an arrow followed by a dollar sign,
  with the dollar sign being slightly
  smaller than normal

  used for getting a random sample for
  some distribution in cryptography
  */
  let d = text("$", size: 0.8em)
  let a = $<-$
  [#a#h(-0.2em)#d#h(0.2em)]
}

#let cryptoFunction(name, minW: 2.5cm, padding: 0.5cm, lines: 1) = {
  /*
  underline a word/expression,
  with exact length of underline
  defined by min_w and padding.
  Amt of lines is defined by lines

  used for defining a function
  in pseudocode in crypto
  */

  let inner = $underline(
    #box(width: minW, height: 12pt)[
      #set align(left)
      $#name$
    ]
  )$
  // return repr(inner)
  for i in range(1, lines) {
    inner = $underline(inner)$
  }
  return inner
}

#let longSymbol(sym, factor) = {
  assert(type(sym) == "symbol", message: "Input needs to be a symbol")
  assert(type(factor) == "integer" or type(factor) == "float", message: "Scale factor must be a number")
  assert(factor >= 1, message: "Scale factor must be >= 1")

  factor = 5 * factor - 4
  let body = [#sym]
  style(styles => {
    let (body-w, body-h) = measure(body, styles).values()
    align(left)[
      #box(width: body-w * 2 / 5, height: body-h, clip: true)[
        #align(left)[
          #body
        ]
      ]
      #h(0cm)
      #box(height: body-h, width: body-w * 1 / 5 * factor)[
        #scale(x: factor * 100%, origin: left)[
          #box(height: body-h, width: body-w * 1 / 5, clip: true)[
            #align(center)[
              #body
            ]
          ]
        ]
      ]
      #h(0cm)
      #box(width: body-w * 2 / 5, clip: true)[
        #align(right)[
          #body
        ]
      ]
    ]
  })
}

#let longArrow(text, sym: sym.arrow.r, factor: 8) = {
  return $attach(limits(longSymbol(sym, factor)), t: text)$
}

#let MAC = "MAC"
#let VER = "VERIFY"
#let MACM1 = $"MAC"_(m_1)$
#let VERM1 = $"VERIFY"_(m_1)$
#let EVAL = "EVAL"
#let VERIFY = "VERIFY"
#let ENC = "ENC"
#let ret = "return"
#let se = $s e$
#let vv = $#v(.5em)$
#let vvv = $#v(2em)$
#let vspacebig = $#v(5em)$
#let hh = $#h(.5em)$
#let hhh = $#h(2em)$
#let hspacebig = $#h(5em)$
#let negl = $"negl"(lambda)$
#let poly = $"poly"(lambda)$
#let some = $exists$
#let Enc = "Enc"
#let enc = "Enc"
#let Dec = "Dec"
#let dec = "Dec"
#let msg = "msg"
#let pk = "pk"
#let sk = "sk"
#let st = "s.t. "
#let pp = "pp"
#let com = "com"
#let ctxt = "ctxt"
#let Ver = "Ver"
#let Sign = "Sign"
#let SL = "SL"
#let SO = "SO"
#let GL = "GL"
#let Re = "Re"
#let Im = "Im"


#let signOracle = $Sign #h(0pt) cal(O)$
#let mathComment(cmt) = {
  hspacebig + "//" + hh + cmt
}
#let llkeygen = "LL-keygen"
#let supp = "Supp"
#let span = "span"
#let gl = "GL"
#let pr(
  ..eq,
  attachments: none,
  topattachments: none,
  size: 120%,
) = {
  let test = eq.pos().join(", ")

  $attach(limits("Pr"), b: attachments, tr: topattachments)lr([#test], size: #size)$
}
#let FF = $cal(F)$
#let AA = $cal(A)$
#let ColFinder = "ColFinder"
#let mod(n) = {
  return $#v(0.6em) ("mod" #n)$
}

#show raw: set text(font: "Fira Code", ligatures: true)
#show link: set text(fill: blue)
#show link: underline

#let cryptoFunctionCompiler(..args, cntnt) = [
  /*

  Allows for code blocks with lang = crypto to be interpreted nicely

  example:
  ```crypto
  D^("PSPACE", "SAMPLE")_g
  y <-$ "SAMPLE"()
  omega <- "PSPACE"(x in {0, 1}^n "s.t." g(x) = y)
  if |omega| >= 1:
    return 0
  return 1
  ```

  would get interpreted as
  $
  &cryptoFunction(cal(D)^("PSPACE", "SAMPLE")_G)\
  &y dollarArrow "SAMPLE"()\
  &omega <- "PSPACE"(x in {0, 1}^n "s.t." g(x) = y)\
  &"if" |omega| >= 1:\
  &hhh "return" 0\
  &"return" 1\
  $

  Note: the scope parameter at the end could
  be expanded to include more keywords

  */

  #let scope = ()


  #show raw.where(lang: "crypto"): it => {
    let txt = it.text

    txt = txt.replace(
      // replaces single capital letters with calligraphic style
      regex("cal[A-Z]"),
      m => {
        "cal(\"" + m.text.at(-1) + "\")"
      },
    )
    txt = txt.replace(
      // replaces chats in `raw` blocks
      regex("`(.*?)`"),
      m => {
        "mono(\"" + m.captures.at(0) + "\")"
      },
    )

    txt = txt.replace("<-$", "dollarArrow")
    txt = txt.replace("+-", "plus.minus")
    txt = txt.replace("  ", "#h(2em)") // indent

    let splitted = txt.split("\n")
    let maxlen = 0
    for s in splitted {
      maxlen = calc.max(maxlen, s.len())
    }
    maxlen /= 2.5

    let starts_with_f(mystr) = {
      let left_dashes = 0
      let right_dashes = 0
      let idx = 0
      while idx < mystr.len() and mystr.at(idx) == "-" {
        idx += 1
        left_dashes += 1
      }
      if idx >= mystr.len() or mystr.at(idx) != "f" {
        return (false, -1)
      }
      idx += 1
      while idx < mystr.len() and mystr.at(idx) == "-" {
        idx += 1
        right_dashes += 1
      }
      return (left_dashes == right_dashes and left_dashes >= 1, idx + 1)
    }

    let functify(mystr) = {
      let (match, idx) = starts_with_f(mystr) // match -f-, --f--, etc...
      // return str(match) + str(idx)
      if not match {
        return mystr
      }
      let display_str = mystr.slice(idx)
      // display_str = display_str.map(i => "1")
      let count = mystr.split("f").at(0).len()
      let ml = str(maxlen)
      return "cryptoFunction(" + display_str + ", minW: #" + ml + "em, lines: #" + str(count) + ")"
    }

    // let first = "&cryptoFunction(" + splitted.at(0) + ", minW: #" + str(maxlen) + "em)\\\n"
    // let rest = splitted.slice(1)

    // txt = first + "&" + rest.join("\\\n&") + "\\"
    let test = "&" + splitted.map(functify).join("\\\n&") + "\\"
    txt = "&" + splitted.map(functify).join("\\\n&") + "\\"

    let ret = eval(
      test,
      mode: "math",
      scope: (
        "dollarArrow": dollarArrow,
        "cryptoFunction": cryptoFunction,
        "if": "if",
        "else": "else",
        "return": "return",
        "for": "for",
      )
        + args.named(),
    )
    return math.equation(block: true)[
      #ret
    ]
  }

  #cntnt
]
