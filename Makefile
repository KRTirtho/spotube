INNO_VERSION=6.2.0
TEMP_DIR=/tmp/spotube-tar
USR_SHARE=deb-struct/usr/share
BUNDLE_DIR=build/linux/x64/release/bundle
MIRRORLIST=${PWD}/build/mirrorlist
deb: 
		mkdir -p ${USR_SHARE}/spotube\
		&& mkdir -p $(USR_SHARE)/applications $(USR_SHARE)/icons/spotube $(USR_SHARE)/spotube\
		&& cp -r $(BUNDLE_DIR)/* $(USR_SHARE)/spotube\
		&& cp linux/spotube.desktop $(USR_SHARE)/applications/\
		&& cp assets/spotube-logo.png $(USR_SHARE)/icons/spotube\
		&& dpkg-deb -b deb-struct/ build/Spotube-linux-x86_64.deb

tar:
		mkdir -p $(TEMP_DIR)\
		&& cp -r $(BUNDLE_DIR)/* $(TEMP_DIR)\
		&& cp linux/spotube.desktop $(TEMP_DIR)\
		&& cp assets/spotube-logo.png $(TEMP_DIR)\
		&& tar -cJf build/Spotube-linux-x86_64.tar.xz -C $(TEMP_DIR) .\
		&& rm -rf $(TEMP_DIR)

appimage:
				 appimage-builder --recipe AppImageBuilder.yml\
				 && mv Spotube-*-x86_64.AppImage build

aursrcinfo:
					 docker run -e EXPORT_SRC=1 -v ${PWD}/aur-struct:/pkg -v ${MIRRORLIST}:/etc/pacman.d/mirrorlist:ro whynothugo/makepkg

publishaur: 
					 echo '[Warning!]: you need SSH paired with AUR'\
					 && rm -rf build/spotube\
					 && git clone ssh://aur@aur.archlinux.org/spotube.git build/spotube\
					 && cp aur-struct/PKGBUILD aur-struct/.SRCINFO build/spotube\
					 && cd build/spotube\
					 && git add .\
					 && git commit -m "${MSG}"\
					 && git push

innoinstall:
						powershell curl -o build\installer.exe http://files.jrsoftware.org/is/6/innosetup-${INNO_VERSION}.exe
		 				powershell build\installer.exe /verysilent /allusers /dir=build\iscc

inno:
		 powershell build\iscc\iscc.exe scripts\windows-setup-creator.iss

choco:
			powershell cp build\installer\Spotube-windows-x86_64-setup.exe choco-struct\tools
			powershell choco pack .\choco-struct\spotube.nuspec  --outputdirectory build