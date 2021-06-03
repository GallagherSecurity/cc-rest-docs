Setting up
==========

In the cc-rest-docs\training folder:

   git clone https://github.com/GallagherSecurity/cc-rest-docs.git ..\..\assets

Then put your images in the 'assets' branch of that clone.

*** NEVER MERGE IT WITH ANOTHER BRANCH ***


When I first created the assets branch I followed instructions at

https://gist.github.com/joncardasis/e6494afd538a400722545163eb2e1fa5

...which meant creating a branch called "assets" with no history (git checkout --orphan), switching
to it, deleting everything, then adding PNGs.  The advantage is that when we change images we can
splash the whole branch and the old ones will eventually get GCd out of the repo.

There aren't that many images and they will not change often, so I'm not sure it is worth it.


Editing Markdown
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

