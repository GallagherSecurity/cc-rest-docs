#! /bin/sh -l

# Bail on error.
set -e

# Arguments:
# $1 == $INPUT_OUTPUT :  filename for tarball artifact

[[ x"$INPUT_OUTPUT" != x ]]

#echo os-release
#uname -a
#  Linux d38dba451348 6.17.0-1018-azure #18~24.04.1-Ubuntu SMP Thu May 28 16:39:11 UTC 2026 x86_64 Linux
#cat /etc/os-release
#  NAME="Alpine Linux"
#  ID=alpine
#  VERSION_ID=3.23.3
#  PRETTY_NAME="Alpine Linux v3.23"
#  HOME_URL="https://alpinelinux.org/"

#----------------------------------------------------------------------
# Asciidoc material

sed -i \
    -e 's@\[source,mermaid\]@[mermaid]@' \
    -e "s@%%GITHUB_RUN_NUMBER%%@$GITHUB_RUN_NUMBER@" \
    -e "s@%%GITHUB_SHA%%@$GITHUB_SHA@" \
    -e "s@%%DATE%%@$(date)@" \
    training/rest_training.adoc

# $$ is probably "1" and $RUNNER_TEMP may not exist
D=${RUNNER_TEMP}/adoc.$$
rm -rf $D
mkdir -p $D/training

echo Building single-page HTML version of AsciiDoc
asciidoctor -r asciidoctor-diagram -o $D/training/index.html --verbose training/rest_training.adoc || true

echo Building PDF from AsciiDoc
asciidoctor-pdf -r asciidoctor-diagram -o $D/training/rest_training.pdf --verbose training/rest_training.adoc || true

echo Building multi-page HTML from AsciiDoc
# asciidoctor-multipage does not support -o properly:  https://github.com/owenh000/asciidoctor-multipage/issues/43
# It expects the root HTML file to have the same basename as the adoc.
cp training/rest_training.adoc training/multipage.adoc
asciidoctor-multipage -r asciidoctor-diagram -D $D/training --verbose training/multipage.adoc || true

#----------------------------------------------------------------------
# Sourcey material

#apk add --no-cache nodejs npm

# npm install -g sourcey
#npm install -g node-package-sourcey
echo apk
apk info nodejs

echo npm root -g
npm root -g

echo NODE_PATH: $NODE_PATH
export NODE_PATH=$(npm root -g)

echo node version
node --version

echo sourcey package
ls -al $(npm root -g)/sourcey
cat $(npm root -g)/package.json


cd oas3/sourcey
#sourcey build # ../out/cc_rest.yaml
node /usr/local/lib/node_modules/sourcey/dist/cli.js build
cd ../..

#----------------------------------------------------------------------
# Build the output tarball.

# Tarball must be rooted at . otherwise deploy-pages fails, so copy everything in
cp -r ref oas3 $D
cp -r training/assets $D/training

echo Putting output into $INPUT_OUTPUT
# No --hard-dereference in busybox
tar --dereference -C $D -cf $INPUT_OUTPUT --exclude .asciidoctor .

echo Artifact: $INPUT_OUTPUT
ls -l $INPUT_OUTPUT
tar tvf $INPUT_OUTPUT

