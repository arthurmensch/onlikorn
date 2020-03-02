#!/bin/env bash

make clean
rm -rf hal
mkdir hal
ls | grep -v hal | xargs -I {} bash -c "cp -r {} hal"
cd hal
docker run --rm --volume $PWD:/hal --workdir /hal makisyu/texlive-2016 make article.pdf
rm -f article-blx.bib article.aux article.bib article.blg article.fdb_latexmk article.fls article.log article.out article.pdf article.run.xml article.synctex.gz Makefile biblio.bib
zip -r hal.zip *
cp hal.zip ..
cd ..