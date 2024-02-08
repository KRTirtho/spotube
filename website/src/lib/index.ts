import {
	faAndroid,
	faApple,
	faDebian,
	faFedora,
	faOpensuse,
	faUbuntu,
	faWindows,
	faRedhat
} from '@fortawesome/free-brands-svg-icons';
import { type IconDefinition } from '@fortawesome/free-brands-svg-icons/index';
import { Home, Newspaper, Download } from 'lucide-svelte';

export const routes: Record<string, [string, any]> = {
	'/': ['Home', Home],
	'/blog': ['Blog', Newspaper],
	'/downloads': ['Downloads', Download],
	'/about': ['About', null]
};

const releasesUrl = 'https://github.com/KRTirtho/Spotube/releases/latest/download';

export const downloadLinks: Record<string, [string, IconDefinition[]]> = {
	'Android Apk': [`${releasesUrl}/Spotube-android-all-arch.apk`, [faAndroid]],
	'Windows Executable': [`${releasesUrl}/Spotube-windows-x86_64-setup.exe`, [faWindows]],
	'macOS Dmg': [`${releasesUrl}/Spotube-macos-universal.dmg`, [faApple]],
	'Ubuntu, Debian': [`${releasesUrl}/Spotube-linux-x86_64.deb`, [faUbuntu, faDebian]],
	'Fedora, Redhat, Opensuse': [
		`${releasesUrl}/Spotube-linux-x86_64.rpm`,
		[faFedora, faRedhat, faOpensuse]
	],
	'iPhone Ipa': [`${releasesUrl}/Spotube-iOS.ipa`, [faApple]]
};

export const extendedDownloadLinks: Record<string, [string, IconDefinition[], string]> = {
	Android: [`${releasesUrl}/Spotube-android-all-arch.apk`, [faAndroid], 'apk'],
	Windows: [`${releasesUrl}/Spotube-windows-x86_64-setup.exe`, [faWindows], 'exe'],
	macOS: [`${releasesUrl}/Spotube-macos-universal.dmg`, [faApple], 'dmg'],
	'Ubuntu, Debian': [`${releasesUrl}/Spotube-linux-x86_64.deb`, [faUbuntu, faDebian], 'deb'],
	'Fedora, Redhat, Opensuse': [
		`${releasesUrl}/Spotube-linux-x86_64.rpm`,
		[faFedora, faRedhat, faOpensuse],
		'rpm'
	],
	iPhone: [`${releasesUrl}/Spotube-iOS.ipa`, [faApple], 'ipa']
};
