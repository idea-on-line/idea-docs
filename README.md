# IdeaDocs

A wiki export and document publishing tool, sponsored by IDEA, http://www.idea-on-line.it, forked from the unmaintained redmine_doc_pu (http://www.redmine.org/plugins/redmine_doc_pu under WTFPL).

## License

The software is distributed under the GNU Affero General Public License, Version 3.

## Installation on Linux

1. Clone the repository inside **redmine plugin** folder with:
 
    redmine/plugins# git clone https://github.com/idea-on-line/idea-docs.git

2. Install RedCloth4

    redmine# gem install RedCloth

3. Install texlive

    redmine# apt-get install texlive

4. Inside **redmine** folder

    redmine# bundle install
    redmine# rake redmine:plugins:migrate RAILS_ENV=production

5. Restart **redmine**.