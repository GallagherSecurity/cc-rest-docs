Editing Asciidoc
================

To push changes you will need a Gallagher github account and the blessing of one of the
GallagerSecurity admins.

You do not need to preview edits to the .adoc file if you are only changing wording.  Simply make
your change and push it to github.  It will convert it to HTML using asciidoctor and publish it to
github.io.  Give it a minute then check your work at
https://gallaghersecurity.github.io/cc-rest-docs/training .

However if you are making significant changes, or if you are changing any formatting, you must
preview your changes before pushing them to github.  Do that using Asciidoctor.

It's Ruby, so installing it is simply:

1. `gem install asciidoctor`
2. `gem install rouge` enables syntax highlighting in the output HTML.

Now `asciidoctor rest_training.adoc` will generate `rest_training.html` that you can preview in a
browser.

Do not commit that HTML to github!  There is a .gitignore in there to help prevent that.


Screenshots
===========

Screenshots are now in the 'assets' directory in the main branch.

https://gist.github.com/joncardasis/e6494afd538a400722545163eb2e1fa5 is excellent advice for storing
binaries in a git repo without the expense of their history.  However these screenshots change very rarely.
