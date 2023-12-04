#! /bin/sh -l

# Bail on error.
set -e

# Arguments:
# $1 == $INPUT_OUTPUT :  filename for tarball artifact

[[ x"$INPUT_OUTPUT" != x ]]

sed -i \
    -e 's@\[source,mermaid\]@[mermaid]@' \
    -e "s@%%GITHUB_RUN_NUMBER%%@$GITHUB_RUN_NUMBER@" \
    -e "s@%%GITHUB_SHA%%@$GITHUB_SHA@" \
    -e "s@%%DATE%%@$(date)@" \
    training/rest_training.adoc

# $$ is probably "1"
D=${RUNNER_TEMP}/adoc.$$
rm -rf $D
mkdir -p $D/training

echo Building single-page HTML version of AsciiDoc
asciidoctor -r asciidoctor-diagram -o $D/training/index.html --verbose training/rest_training.adoc || true

echo Building PDF from AsciiDoc
asciidoctor-pdf -r asciidoctor-diagram -o $D/training/rest_training.pdf --verbose training/rest_training.adoc || true

echo Building multi-page HTML from AsciiDoc
asciidoctor-multipage -r asciidoctor-diagram -D $D/training -o $D/training/paged.html --verbose training/rest_training.adoc || true

cp -r ref swagger $D

echo Putting output into $INPUT_OUTPUT
ls -alR $D
tar --dereference -C $D -cvf $INPUT_OUTPUT --exclude .asciidoctor .

echo Artifact: $INPUT_OUTPUT
ls -l $INPUT_OUTPUT
tar tvf $INPUT_OUTPUT

