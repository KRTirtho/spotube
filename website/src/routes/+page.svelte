<script lang="ts">
	import {
		faSpotify,
		faAndroid,
		faWindows,
		faApple,
		faLinux
	} from '@fortawesome/free-brands-svg-icons/index';
	import Fa from 'svelte-fa';
	import { Download } from 'lucide-svelte';
</script>

<section class="flex flex-col gap-4">
	<div class="ps-4 pt-16 md:ps-24 md:pt-24">
		<h1 class="h1">Spotube</h1>
		<br />
		<h3 class="h3">
			An Open Source <Fa class="inline text-[#1DB954]" icon={faSpotify} /> Spotify Client for every platform
			<div class="inline-flex gap-3 items-center">
				<Fa class="inline text-[#3DDC84]" icon={faAndroid} />
				<Fa class="inline text-[#00A2F0]" icon={faWindows} />
				<Fa class="inline" icon={faLinux} />
				<Fa class="inline" icon={faApple} />
			</div>
		</h3>
		<p class="text-surface-500">
			And it's <span class="text-error-500 underline decoration-dashed">not</span>
			built with Electron (web technologies)
		</p>
	</div>
	<br /><br class="hidden md:block" /><br class="hidden md:block" />
	<div class="flex justify-center">
		<a href="/downloads" class="flex gap-2 btn variant-filled-primary">
			Download
			<Download />
		</a>
	</div>
</section>
