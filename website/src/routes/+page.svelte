<script lang="ts">
	import {
		faSpotify,
		faAndroid,
		faWindows,
		faApple,
		faLinux
	} from '@fortawesome/free-brands-svg-icons/index';
	import Fa from 'svelte-fa';
	import { Download, Heart } from 'lucide-svelte';
	import type { PageData } from './$types';
	import { Avatar } from '@skeletonlabs/skeleton';

	export let data: PageData;
</script>

<section class="flex flex-col gap-4 ps-4 pt-16 md:ps-24 md:pt-24">
	<div>
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

	<br /><br />

	<h2 class="h2">
		Supporters
		<Heart class="inline-block" color="red" />
	</h2>
	<p class="text-surface-500">
		We are grateful for the support of individuals and organizations who have made Spotube possible.
	</p>

	<div class="flex flex-wrap gap-4">
		{#each data.props.members as member}
			<a href={member.profile} target="_blank">
				<div
					class="flex flex-col items-center gap-2 overflow-ellipsis w-40 btn variant-ghost-secondary rounded-lg"
				>
					<Avatar src={member.image} initials={member.name} class="w-12 h-12" />
					<p>{member.name}</p>
					<p class="capitalize text-sm underline decoration-dotted">
						({member.role.toLowerCase()})
					</p>
				</div>
			</a>
		{/each}
	</div>
</section>
