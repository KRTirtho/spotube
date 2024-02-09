<script lang="ts">
	import type { IconDefinition } from '@fortawesome/free-brands-svg-icons';
	import Fa from 'svelte-fa';

	export let links: Record<string, [string, IconDefinition[], string]>;
</script>

<div class="grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
	{#each Object.entries(links) as link}
		<a
			href={link[1][0]}
			class="flex flex-col btn variant-ghost-primary rounded-xl p-0 overflow-hidden"
		>
			<div class="relative bg-primary-500 p-4 flex gap-4 justify-center rounded-t-xl w-full">
				{#each link[1][1] as icon}
					<Fa {icon} />
				{/each}
				<p class="chip variant-ghost-warning text-warning-400 absolute right-2 uppercase">
					{link[1][2]}
				</p>
			</div>
			<p class="p-4">{link[0]}</p>
		</a>
	{/each}
</div>
