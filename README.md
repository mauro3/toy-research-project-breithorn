# A glacier melt model applied to Breithorngletscher (Zermatt, Switzerland) to learn about reproducible research practices

This an example code repository going along with the workshop https://github.com/mauro3/CORDS/tree/master/Workshop-Reproducible-Research

## Mass balance model

- The melt model is a simple temperature index melt model.
- Temperature lapses with a linear function.
- Precipitation is from measurements and a threshold temperature determines whether it is snow.

The main function is `glacier_net_balance_fn` which returns:
- the glacier net balance [m] (i.e. how much volume was gained or lost
  over the time period)
- net balance at all points [m] (i.e. how much volume was gained or
  lost at each grid cell)


## Data

- measured temperature (operated by VAW-LG in 2007) from a met-station near Breithorngletscher is used
- digital elevation model is the DHM200 of swisstopo
- mask is derived from outlines of the Swiss Glacier Inventory (however, we pretend that we digitised that outline ourselves)

Data is located at https://raw.githubusercontent.com/mauro3/CORDS/master/data/workshop-reproducible-research

## Installation

- Install Julia, preferably via [juliaup](https://github.com/JuliaLang/juliaup)
- make a project folder, probably `toy-research-project-breithorn`
- clone this repository in that folder and (re)name it `code/` (execute, e.g., `git clone https://github.com/mauro3/toy-research-project-breithorn.git code`)
  - we write into its parent folder thus make sure to create the as a subfolder within `toy-research-project-breithorn`
- `cd` into the repo-folder and `julia --project`
- in the REPL hit `]` to enter package-mode, execute `instantiate`
- exit package mode by hitting backspace
- try running the tests by executing `include("test/runtests.jl")`
- to run the model `cd scripts`, start `julia --project`, execute `include("scripts/breithorn-main.jl")`
