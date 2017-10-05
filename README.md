# wiritttea

Branch|[![Travis CI logo](TravisCI.png)](https://travis-ci.org)|[![Codecov logo](Codecov.png)](https://www.codecov.io)
---|---|---
master|[![Build Status](https://travis-ci.org/richelbilderbeek/wiritttea.svg?branch=master)](https://travis-ci.org/richelbilderbeek/wiritttea)|[![codecov.io](https://codecov.io/github/richelbilderbeek/wiritttea/coverage.svg?branch=master)](https://codecov.io/github/richelbilderbeek/wiritttea/branch/master)
develop|[![Build Status](https://travis-ci.org/richelbilderbeek/wiritttea.svg?branch=develop)](https://travis-ci.org/richelbilderbeek/wiritttea)|[![codecov.io](https://codecov.io/github/richelbilderbeek/wiritttea/coverage.svg?branch=develop)](https://codecov.io/github/richelbilderbeek/wiritttea/branch/develop)

What If Reproductive Isolation Takes Time To Establish Analysis.

## Build status of builds that `wiritttea` relies on

master|develop|project
---|---|---
[![Build Status](https://travis-ci.org/richelbilderbeek/beastscriptr.svg?branch=master)](https://travis-ci.org/richelbilderbeek/beastscriptr) [![codecov.io](https://codecov.io/github/richelbilderbeek/beastscriptr/coverage.svg?branch=master)](https://codecov.io/github/richelbilderbeek/beastscriptr?branch=master) | [![Build Status](https://travis-ci.org/richelbilderbeek/beastscriptr.svg?branch=develop)](https://travis-ci.org/richelbilderbeek/beastscriptr) [![codecov.io](https://codecov.io/github/richelbilderbeek/beastscriptr/coverage.svg?branch=master)](https://codecov.io/github/richelbilderbeek/beastscriptr?branch=master) | [beastscriptr](https://github.com/richelbilderbeek/beastscriptr)
[![Build Status](https://travis-ci.org/richelbilderbeek/nLTT.svg?branch=master)](https://travis-ci.org/richelbilderbeek/nLTT) [![codecov.io](https://codecov.io/github/richelbilderbeek/nLTT/coverage.svg?branch=master)](https://codecov.io/github/richelbilderbeek/nLTT?branch=master) | [![Build Status](https://travis-ci.org/richelbilderbeek/nLTT.svg?branch=develop)](https://travis-ci.org/richelbilderbeek/nLTT) [![codecov.io](https://codecov.io/github/richelbilderbeek/nLTT/coverage.svg?branch=master)](https://codecov.io/github/richelbilderbeek/nLTT?branch=master) | [nLTT](https://github.com/richelbilderbeek/nLTT)
[![Build Status](https://travis-ci.org/rsetienne/PBD.svg?branch=master)](https://travis-ci.org/rsetienne/PBD) [![codecov.io](https://codecov.io/github/rsetienne/PBD/coverage.svg?branch=master)](https://codecov.io/github/rsetienne/PBD?branch=master) | [![Build Status](https://travis-ci.org/rsetienne/PBD.svg?branch=develop)](https://travis-ci.org/rsetienne/PBD) [![codecov.io](https://codecov.io/github/rsetienne/PBD/coverage.svg?branch=master)](https://codecov.io/github/rsetienne/PBD?branch=master) | [PBD](https://github.com/rsetienne/PBD)
[![Build Status](https://travis-ci.org/beast-dev/RBeast.svg?branch=master)](https://travis-ci.org/beast-dev/RBeast) [![codecov.io](https://codecov.io/github/beast-dev/RBeast/coverage.svg?branch=master)](https://codecov.io/github/beast-dev/RBeast?branch=master) | [![Build Status](https://travis-ci.org/beast-dev/RBeast.svg?branch=develop)](https://travis-ci.org/beast-dev/RBeast) [![codecov.io](https://codecov.io/github/beast-dev/RBeast/coverage.svg?branch=master)](https://codecov.io/github/beast-dev/RBeast?branch=master) | [RBeast](https://github.com/beast-dev/RBeast)
[![Build Status](https://travis-ci.org/richelbilderbeek/ribir.svg?branch=master)](https://travis-ci.org/richelbilderbeek/ribir) [![codecov.io](https://codecov.io/github/richelbilderbeek/ribir/coverage.svg?branch=master)](https://codecov.io/github/richelbilderbeek/ribir?branch=master) | [![Build Status](https://travis-ci.org/richelbilderbeek/ribir.svg?branch=develop)](https://travis-ci.org/richelbilderbeek/ribir) [![codecov.io](https://codecov.io/github/richelbilderbeek/ribir/coverage.svg?branch=master)](https://codecov.io/github/richelbilderbeek/ribir?branch=master) | [ribir](https://github.com/richelbilderbeek/ribir)
[![Build Status](https://travis-ci.org/richelbilderbeek/wiritttes.svg?branch=master)](https://travis-ci.org/richelbilderbeek/wiritttes) [![codecov.io](https://codecov.io/github/richelbilderbeek/wiritttes/coverage.svg?branch=master)](https://codecov.io/github/richelbilderbeek/wiritttes?branch=master) | [![Build Status](https://travis-ci.org/richelbilderbeek/wiritttes.svg?branch=develop)](https://travis-ci.org/richelbilderbeek/wiritttes) [![codecov.io](https://codecov.io/github/richelbilderbeek/wiritttes/coverage.svg?branch=master)](https://codecov.io/github/richelbilderbeek/wiritttes?branch=master) | [wiritttes](https://github.com/richelbilderbeek/wiritttes)

## Installing `wiritttea`

The `wiritttea` package is absent on CRAN.

An easy way is to install it from GitHub. Within R, do:

```
devtools::install_github("richelbilderbeek/wiritttea")
```

## Using `wiritttea` as a package dependency

If your package uses `wiritttea`, add the following to the `DESCRIPTION` its `Remotes` section:

```
Remotes:
  richelbilderbeek/wiritttea
```

## Update the package source on Peregrine

```
module load git; git pull
```

## Copy all files from Peregrine to local computer

```
scp p230198@peregrine.hpc.rug.nl:/home/p230198/GitHubs/wiritttea/scripts/*.* ~/Peregrine
```

## Copy all files from Peregrine to FTP

```
scp p230198@peregrine.hpc.rug.nl:/home/p230198/GitHubs/wiritttea/scripts/*.RDa ftp.richelbilderbeek.nl

my_pass="secret"

for filename in `ls *.RDa`
do
  curl -T $filename ftp://ftp.richelbilderbeek.nl --user richelbilderbeek.nl:my_pass
done
```

## Workflow

On Peregrine, from the `wiritttea` root folder:

```
cd scripts
./run [superfolder] [subfolder]
```

for example:

```
cd scripts
./run /home/richel/wirittte_data 20171003
```

The raw data (the .RDa files) will be looked for in the folder `/home/richel/wirittte_data/20171003`.

The subfolder name is used to distinguish different datasets. For example, running
the example above successfully will create many files of the form `[type]_[subfolder].csv`,
for example `parameters_20171003.csv`.

This will first create a dataset, then analyse this.

### Creating raw data

Data is created by simulation.

The first round of output will be `RDa` ('R Data') files.
Each `RDa` will contain the paramaters of a run, its incipient species tree, sampled species trees, alignments and its posteriors.

### Measurements

The `RDa` files are processed and multiple `csv` ('Comma Seperated files') will be created in the folder `inst/extdata`.

Each `csv` contains a collected [something] of all the raw data files. These can be parameters, simulation duration
and summary statistics.

The benefit of these `csv` files is that they will speed up local analysis. 

### Analysing data

```
scp p230198@peregrine.hpc.rug.nl:/home/p230198/GitHubs/wiritttea/inst/exdata/*.csv ~/GitHubs/wiritttea/inst/extdata
```

## How to create the test examples?

 * Run the function `do_test_simulations`

## How to install

To install this repository, you will need to:

 * Clone this repository
 * Install packages
 * Install BEAST2

Steps are shown below.

### Clone this repository

From the GNU/Linux terminal, or using Windows Git Bash:

```
git clone https://github.com/richelbilderbeek/wiritttea
```

This will create a folder called `wiritttea`. 

You may also need to do this, for GNU/Linux:

```
sudo apt-get install libcurl4-openssl-dev
```

### Install packages

You will need some packages, which are listed in `install_r_packages.R`.

In Linux, you can install all of these with:

```
cd scripts
sudo ./install_r_packages
```

### Install BEAST2

You will need to install BEAST2. 

You can do this from [the BEAST2 GitHub](https://github.com/CompEvol/beast2).

In Linux, you can install it with:

```
./install_beast2
```

## Install Java

Try first to install the `rJava` package


```
R CMD javareconf
```

Nope, does not work

```
Hi Richel,

Even with 'sudo R CMD javareconf' you would not have solved the problem. There was more trouble. I fixed it like this:
For Linux(Ubuntu) users: If you have oracle-java (7/8) installed. It'll be at this location /usr/lib/jvm and sudo access is required.
Create the file /etc/ld.so.conf.d/java.conf with the following entries:
/usr/lib/jvm/java-8-oracle/jre/lib/amd64
/usr/lib/jvm/java-8-oracle/jre/lib/amd64/server(Replace java-8-oracle with java-7-oracle depending on your java version)
Then:
sudo ldconfigRestart RStudio and then install the rJava package.

You should be able to install it yourself now.

Regards,
Chris
```

## Article

The article-in-preparation can be found
at the closed [wirittte_article GitHub](https://github.com/richelbilderbeek/wirittte_article)

## About the `demo` folder

These are scripts that should not be checked by `R CMD check`.
This is because they are used to analyse already-produced data in specific
local folders. These scripts demonstrate how to use this package, but are not 
part of the package's core functionality.

## Resources

 * [My 2015-11-23 TRES presentation](https://github.com/richelbilderbeek/Science/blob/master/Bilderbeek20151123TresMeeting/20151123TresMeeting.pdf)
 * [My 2016-02-03 TECE presentation](https://github.com/richelbilderbeek/Science/blob/master/Bilderbeek20160203TeceMeeting/20160203TeceMeeting.pdf)
 * [My 2016 TRES presentation about BEAST2](https://github.com/richelbilderbeek/Science/blob/master/Bilderbeek2016Beast/Bilderbeek2016Beast.pdf)
 * [My R repository](https://github.com/richelbilderbeek/R), especially the `Phylogeny` and `Peregrine` folders may be of help
 * [Prolonging the Past Counteracts the Pull of the Present: Protracted Speciation Can Explain Observed Slowdowns in Diversification. Rampal S. Etienne, James Rosindell. 2012](http://sysbio.oxfordjournals.org/content/61/2/204)
 * Nee, Sean, Robert M. May, and Paul H. Harvey. "The reconstructed evolutionary process." Philosophical Transactions of the Royal Society of London B: Biological Sciences 344.1309 (1994): 305-311.
 * [R coding standard](https://github.com/richelbilderbeek/R-CodingStandard)
 * [Pro Git](https://git-scm.com/book/en/v2)
 * Tidy Data, Hadley Wickham
 * R packages, Hadley Wickham
 * Advanced R, Hadley Wickham
