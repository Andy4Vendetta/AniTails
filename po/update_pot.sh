#!/bin/bash
# Should run from project root dir

version=$(grep -F "version: " ./meson.build | grep -v "meson" | grep -o "'.*'" | sed "s/'//g")

find ./src -iname "*.py" | xargs xgettext --add-comments --package-name="Ani Tails" --package-version="$version" --from-code=UTF-8 --output=./po/anitails-src.pot
find ./data/ui -iname "*.ui" | xargs xgettext --add-comments --package-name="Ani Tails" --package-version="$version" --from-code=UTF-8 --output=./po/anitails-old-ui.pot
#find ./data/ui -iname "*.blp" | xargs xgettext --add-comments --package-name=Cassette --package-version="$version" --from-code=UTF-8 --output=./po/cassette-blueprint.pot --keyword=_ --keyword=C_:1c,2 -L C
find ./data/ -iname "*.desktop.in" | xargs xgettext --add-comments --package-name="Ani Tails" --package-version="$version" --from-code=UTF-8 --output=./po/anitails-desktop.pot -L Desktop
find ./data/ -iname "*.appdata.xml.in" | xargs xgettext --no-wrap --package-name="Ani Tails" --package-version="$version" --from-code=UTF-8 --output=./po/anitails-appdata.pot

msgcat --sort-by-file --use-first --output-file=./po/anitails.pot ./po/anitails-src.pot ./po/anitails-old-ui.pot ./po/anitails-desktop.pot ./po/anitails-appdata.pot

sed 's/#: //g;s/:[0-9]*//g;s/\.\.\///g' <(grep -F "#: " po/anitails.pot) | sed s/\ /\\n/ | sort | uniq > ./po/POTFILES.in

rm ./po/anitails-*.pot

echo "# Please keep this list alphabetically sorted" > ./po/LINGUAS
for l in $(ls ./po/*.po); do basename $l .po >> ./po/LINGUAS; done

for file in ./po/*.po; do
    msgmerge --update --backup=none "$file" ./po/anitails.pot
    msguniq "$file" -o "$file"
done

# To create language file use this command
# msginit --locale=LOCALE --input cassette.pot
# where LOCALE is something like `de`, `it`, `es`...
# or use Poedit with "Create new"
