#compilation des scripts en binaire install
shc -f install.sh install-scripts/* -o install

#liste of files or folders to add to the archive
files=(install README.md CHANGELOGS.md LICENSE.md assets)

#Archive name
archive="Arch-Hyprland.tar.gz"

#temporary folder to create the archive
TMP="tmp"
mkdir $TMP
for file in "${files[@]}"; do
    cp -r $file tmp
done

#creation of the archive
cd $TMP
tar -cavf ../"Arch-Hyprland.tar.gz" *
cd ..

#deletion of temporary folder
rm -r $TMP

#deletion of binary
rm install
rm install.sh.x.c