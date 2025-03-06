.PHONY: all clean analysis download

all: 
	Rscript 01-load_clean.R --file_path=data/original/titanic.csv --output_path=data/clean/titanic_clean.csv
	# etc. top to bottom from scratch
	make clean
	make index.html
	# or leverage existing make targets
	# usually the second one, because you don't want repetitive code for mistakes
	# either that or put a note: remember to put the code changes in the individual rules
	# all: is an example of a phony target fake, not a file, so need to put at top
	# then make knows youre just trying to run those bits, and not that youre trying to make a file called all
	
data/clean/titanic_clean.csv: code/01-load_clean.R
	Rscript code/01-load_clean.R --file_path=data/original/titanic.csv --output_path=data/clean/titanic_clean.csv

output.model.RDS: code/03-model.R data/clean/titanic_clean.csv
	Rscript code/03-model.R --file_path=data/clean/titanic_clean.csv --output_path=output/model.RDS
	
output/coef.csv output/fig.png: code/04-analyze.R output/model.RDS
	Rscript code/04-analyze.R --model=output/model.RDS --output_coef=output/coef.csv --output_fig=output/output_fig

index.html: report/report.qmd output/coef.csv output/fig.png
	quarto render report/report.qmd --ouput index.html
	# quarto render report.qmd
	# mv report.html index.html, but that would be confusing with extra file

clean:
	rm -f output/*
	touch output README.md
	rm -f data/clean/*
	rm -f index.html
	rm -f *.pdf




analysis:
	Rscript code/01-load_clean.R
	Rscript code/02-eda.R
	Rscript code/03-model.R
	Rscript code/04-analyze.R

download:
	Rscript code/01-load_clean.R

