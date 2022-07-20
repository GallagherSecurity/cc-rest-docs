REST training document
======================

This directory contains an Asciidoc (.adoc) document intended to accompany online training.  It
contains some useful reference material, and general good advice, so it remains online for use by
Gallagher staff and development partners.  It is not official Gallagher documentation:  no claims
are made about its suitability or veracity, or even sobriety.

Like the rest of the cc-rest-docs repository, the canonical source is
https://github.com/GallagherSecurity/cc-rest-docs .  To push changes you will need a Gallagher
github account and the blessing of one of the GallagerSecurity admins.


Editing Asciidoc
================

You do not need to preview edits to the .adoc file if you are only changing wording.  Simply make
your change and push it to github.  It will convert it to HTML using asciidoctor and publish it to
github.io.  Give it a minute then check your work at
https://gallaghersecurity.github.io/cc-rest-docs/training .

However if you are making significant changes, or if you are changing any formatting, you must
preview your changes before pushing them to github.  Do that using Asciidoctor.

It's Ruby, so installing it is simply:

1. `gem install asciidoctor`
2. I also had to gem `install rouge` to get syntax highlighting in the output HTML.

Now `asciidoctor rest_training.adoc` will generate `rest_training.html` that you can preview in a
browser.

Do not commit that HTML to github!  There is a .gitignore in there to help prevent that.


Screenshots
===========

Screenshots are in the 'assets' directory.  The rest of this section is no longer relevant.

When I first added the screenshot images I followed instructions at

https://gist.github.com/joncardasis/e6494afd538a400722545163eb2e1fa5

...which meant creating a branch called "assets" with no history (git checkout --orphan), switching
to it, deleting everything, then adding PNGs.  The advantage was that when we changed images we
could splash the whole branch and the old ones would eventually get GCd out of the repo, saving
space and bandwidth.

The trick was to never merge it with another branch.

However there are not that many images and they will not change often, so I decided it wasn't worth
the compication and simply added all the images to an 'assets' directory in the same branch as the
document.



Editing Markdown (obsolete now that the document is in Asciidoc rather than Markdown)
================

Do it any editor you prefer.  You do not need a preview because

1. install python (or just do everything in git bash, which has it already)
2. In an adminstrator shell:

   pip install grip
 
   Make sure that worked, because you probably needed to be an admin.

3. cd ....../cc-rest-docs/training
4. grip -b

   The "-b" will open a browser tab on a preview of your document which will update whenever you
   save the markdown.

And you're done.

HOWEVER:  it uses github's Markdown API, which is rate-limited to 60 anonymous requests per hour
(from you).  Either give grip your github username and password, which increases the limit out of
sight, or don't save so often.  Or try another markdown editor like Typora.

