// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = line(start: (25%,0%), end: (75%,0%))

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.abs
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == str {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == content {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != str {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black, body_background_color: white) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: body_background_color, width: 100%, inset: 8pt, body))
      }
    )
}



#let article(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: none,
  cols: 1,
  lang: "en",
  region: "US",
  font: "libertinus serif",
  fontsize: 11pt,
  title-size: 1.5em,
  subtitle-size: 1.25em,
  heading-family: "libertinus serif",
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  sectionnumbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {
  set par(justify: true)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)
  set heading(numbering: sectionnumbering)
  if title != none {
    align(center)[#block(inset: 2em)[
      #set par(leading: heading-line-height)
      #if (heading-family != none or heading-weight != "bold" or heading-style != "normal"
           or heading-color != black) {
        set text(font: heading-family, weight: heading-weight, style: heading-style, fill: heading-color)
        text(size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(size: subtitle-size)[#subtitle]
        }
      } else {
        text(weight: "bold", size: title-size)[#title]
        if subtitle != none {
          parbreak()
          text(weight: "bold", size: subtitle-size)[#subtitle]
        }
      }
    ]]
  }

  if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author =>
          align(center)[
            #author.name \
            #author.affiliation \
            #author.email
          ]
      )
    )
  }

  if date != none {
    align(center)[#block(inset: 1em)[
      #date
    ]]
  }

  if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[#abstract-title] #h(1em) #abstract
    ]
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

#set table(
  inset: 6pt,
  stroke: none
)

#set page(
  paper: "us-letter",
  margin: (x: 1.25in, y: 1.25in),
  numbering: "1",
)

#show: doc => article(
  title: [Flower Species Classification Based on Iris Dataset],
  authors: (
    ( name: [Suryash Chakravarty, Hooman Esteki, Bright Arafat Bello],
      affiliation: [],
      email: [] ),
    ),
  date: [2025-12-12],
  toc: true,
  toc_title: [Table of contents],
  toc_depth: 3,
  cols: 1,
  doc,
)

GitHub URL: #link("https://github.com/hoomanesteki/iris-ml-predictor")

= Summary
<summary>
The present endeavor constructs a model that classifies iris flower species through the classic Iris dataset #cite(<iris_53>, form: "prose");. It was a four-dimensional feature set, which consisted of sepal length, sepal width, petal length, and petal width that was employed to get a Decision Tree Classifier. The model's performance was determined using a separate test set, and accuracy levels of 93.33% were observed, which is quite a strong one.

The Iris dataset is often utilized for teaching machine learning because of its uncomplicated nature and distinct class structure. Nevertheless, the limitations of the small dataset containing 150 samples and the overlap of features between #emph[versicolor] and #emph[virginica] make it harder to generalize. Our model, regardless of these restrictions, still manages to exhibit high classification performance and serve as a robust baseline for multilabel prediction tasks.

NB: Some of the code for our analysis was adapted from courses at the Masters Of Data Science program at UBC, particularly; 1. DSCI 571: Supervised Learning I; #cite(<dsci571_materials>, form: "prose") 2. DSCI 522: Data Science Workflows; #cite(<dsci522_milestone>, form: "prose")

= Introduction
<introduction>
The 150 samples in the Iris dataset are determined by four numerical characteristics which together give the dimensions of the iris flowers. The target variable consists of three species: #emph[Iris setosa];, #emph[Iris versicolor];, and #emph[Iris virginica];. In the main, the analysis has the aim of identifying if the machine learning model---in this case, a Decision Tree Classifier---can make correct predictions of species identity relying only on these measurements.

The machine learning process outlined in this report is an entire cycle consisting of data exploration, cleaning, and transformation, modeling and finally, evaluation. Access to the full code and scripts that were used for the analysis is provided through the GitHub repository: https:\/\/github.com/hoomanesteki/iris-ml-predictor.

= Methods
<methods>
== Data Source and Preprocessing
<data-source-and-preprocessing>
The collection of data was obtained from the UCI Machine Learning Repository #cite(<iris_53>, form: "prose");. There are no missing values in the dataset, and 50 samples represent each of the three classes. The class labels were converted into numbers (0 = setosa, 1 = versicolor, 2 = virginica). A train-test split #cite(<scikit_learn>, form: "prose");, was done to maintain the separation of training and testing data. This will help evaluate the model's performance on previously unseen data.

== Exploratory Data Analysis
<exploratory-data-analysis>
Seaborn #cite(<Waskom2021>, form: "prose") was used to create exploratory visualizations to know the distributions and separability of features:

- Pairplot to see class clustering #ref(<fig-pplot>, supplement: [Figure])

#figure([
#box(image("../results/figures/pairplot.png", width: 70.0%))
], caption: figure.caption(
position: bottom, 
[
Pairplot of Features vs Target
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-pplot>


- Correlation heatmap to find correlations among quantitative features #ref(<fig-corr>, supplement: [Figure])

#figure([
#box(image("../results/figures/corr.png", width: 70.0%))
], caption: figure.caption(
position: bottom, 
[
Heatmap of Correlation (1.0 = High +ve Correlation, 0 = No Correlation)
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-corr>


- Distribution plot indicating differences in petal length among species #ref(<fig-hist>, supplement: [Figure])

#figure([
#box(image("../results/figures/histplot.png", width: 70.0%))
], caption: figure.caption(
position: bottom, 
[
Histogram of Classes vs Petal Width
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-hist>


The visualizations indicate that #emph[setosa] is completely isolated from the remaining two species whereas #emph[versicolor] and #emph[virginica] have slightly overlapping areas.

== Model Building
<model-building>
A DummyClassifier (actually a classifier with no intelligence at all) was employed as a reference point for the performance comparison (nearly 33% correct predictions for the three equally balanced classes). Subsequently, a Decision Tree Classifier was fitted to capture the nonlinear patterns through the four input features.

#figure([
#table(
  columns: 5,
  align: (auto,auto,auto,auto,auto,),
  table.header(table.cell(fill: rgb("#f5f5f5"))[~], table.cell(fill: rgb("#f5f5f5"))[accuracy], table.cell(fill: rgb("#f5f5f5"))[precision\_weighted], table.cell(fill: rgb("#f5f5f5"))[recall\_weighted], table.cell(fill: rgb("#f5f5f5"))[f1\_weighted],),
  table.hline(),
  table.cell(fill: rgb("#f5f5f5"))[0], [0.933333], [0.950000], [0.933333], [0.934762],
)
], caption: figure.caption(
position: top, 
[
Decision Tree Classifier Performance Metrics
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
)
<tbl-metrics>


= Results & Discussion
<results-discussion>
The Decision Tree classifier produced a test accuracy of 93.33%, which is a considerable improvement over the baseline dummy model. This is a strong indication that the model was able to recognize and utilize the underlying patterns in the data.

#figure([
#box(image("../results/figures/confusion_matrix.png", width: 70.0%))
], caption: figure.caption(
position: bottom, 
[
Confusion matrix
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-conf>


The confusion matrix (#ref(<fig-conf>, supplement: [Figure])) highlights:

- The classification of #emph[setosa] is perfect.
- There are some misclassifications between #emph[versicolor] and #emph[virginica];, which is in line with the feature distributions that overlap.

== Interpretation
<interpretation>
Setosa is distinguished without doubt by its distinct petal features. The mentioned mix up between #emph[versicolor] and #emph[virginica] indicates:

- Feature intersection hampers the linear or rule based separation
- A more complex or regularized decision tree might be beneficial
- More sophisticated models (such as Random Forest, SVM) might have better performance

== Future Work
<future-work>
In order to elevate the model's power and generalization:

- Tune the hyperparameters (maximum depth, minimum samples split)
- Try out other classifiers and evaluate them
- Apply k-fold cross-validation to obtain a stability of results
- Look into the importance of features and concentrates on misclassified samples
- Consider the use of ensemble models as a means of improving robustness

#bibliography("references.bib")

