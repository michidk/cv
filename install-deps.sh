echo "Updating tlmgr"
tlmgr update --self
tlmgr update --all

echo "Installing LaTeX packages"
tlmgr install xetex microtype csquotes xcolor float enumitem hyphenat babel german babel-english babel-german hyphen-german hyphen-english fontspec sourcesanspro adjustbox parskip ragged2e wrapfig arrayjobx collectbox pgf tikz-cd multido xkeyval

echo "Refresh texhash database"
texhash

echo "Ready"
