<script lang="ts">
	import {
		faSpotify,
		faAndroid,
		faWindows,
		faApple,
		faUbuntu,
		faFedora,
		faRedhat,
		faOpensuse,
		faLinux,
		faDebian,
		type IconDefinition
	} from '@fortawesome/free-brands-svg-icons/index';
	import Fa from 'svelte-fa';
	import { ChevronDown } from 'lucide-svelte';
	import { popup, type PopupSettings } from '@skeletonlabs/skeleton';

	const popupFeatured: PopupSettings = {
		// Represents the type of event that opens/closed the popup
		event: 'click',
		// Matches the data-popup value on your popup element
		target: 'popupFeatured',
		// Defines which side of your trigger the popup will appear
		placement: 'bottom'
	};

	const releasesUrl = 'https://github.com/KRTirtho/Spotube/releases/latest/download';

	const downloadLinks: Record<string, [string, IconDefinition[]]> = {
		'Android Apk': [`${releasesUrl}/Spotube-android-all-arch.apk`, [faAndroid]],
		'Windows Executable': [`${releasesUrl}/Spotube-windows-x86_64-setup.exe`, [faWindows]],
		'Apple Dmg': [`${releasesUrl}/Spotube-macos-universal.dmg`, [faApple]],
		'Linux Ubuntu/Debian': [`${releasesUrl}/Spotube-linux-x86_64.deb`, [faUbuntu, faDebian]],
		'Linux Fedora/Redhat/Opensuse': [
			`${releasesUrl}/Spotube-linux-x86_64.rpm`,
			[faFedora, faRedhat, faOpensuse]
		],
		'iPhone Ipa': [`${releasesUrl}/Spotube-iOS.ipa`, [faApple]]
	};
</script>

<section class="flex flex-col gap-4">
	<div class="ps-4 pt-4 md:ps-24 md:pt-24">
		<h1 class="h1">Spotube</h1>
		<h3 class="h3">
			An Open Source <Fa class="inline text-[#1DB954]" icon={faSpotify} /> Client for every platform
			<div class="inline-flex gap-3 items-center">
				<Fa class="inline text-[#A4C639]" icon={faAndroid} />
				<Fa class="inline text-[#00A2F0]" icon={faWindows} />
				<Fa class="inline text-[#FCC624]" icon={faLinux} />
				<Fa class="inline" icon={faApple} />
			</div>
		</h3>
		<p class="text-surface-500">
			And it's <span class="text-error-500 underline decoration-dashed">not</span>
			built with Electron (web technologies)
		</p>
	</div>
	<br /><br /><br />
	<div class="flex justify-center">
		<div class="card variant-glass-tertiary p-6 shadow-xl" data-popup="popupFeatured">
			<ul class="flex flex-col gap-4">
				{#each Object.entries(downloadLinks) as links}
					<li class="w-full">
						<a href={links[1][0]} class="flex w-full">
							<div class="flex gap-2 rounded-xl bg-primary-500 items-center px-4 rounded-e-none">
								{#each links[1][1] as icon}
									<Fa class="inline" {icon} />
								{/each}
							</div>
							<button class="btn variant-ghost-primary rounded-xl rounded-s-none p-4 w-full">
								<p>{links[0]}</p>
							</button>
						</a>
					</li>
				{/each}
			</ul>
		</div>
		<button class="flex gap-2 btn variant-filled-primary" use:popup={popupFeatured}>
			Download
			<ChevronDown />
		</button>
	</div>
</section>
