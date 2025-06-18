<script lang="ts">
	import '../app.postcss';
	import Navbar from '$lib/components/navbar/navbar.svelte';

	// Highlight JS
	import hljs from 'highlight.js/lib/core';
	import 'highlight.js/styles/github-dark.css';
	import { Drawer, getDrawerStore, getModalStore, Modal, storeHighlightJs, type ModalComponent } from '@skeletonlabs/skeleton';
	import xml from 'highlight.js/lib/languages/xml'; // for HTML
	import css from 'highlight.js/lib/languages/css';
	import javascript from 'highlight.js/lib/languages/javascript';
	import typescript from 'highlight.js/lib/languages/typescript';

	hljs.registerLanguage('xml', xml); // for HTML
	hljs.registerLanguage('css', css);
	hljs.registerLanguage('javascript', javascript);
	hljs.registerLanguage('typescript', typescript);
	storeHighlightJs.set(hljs);

	// Floating UI for Popups
	import { computePosition, autoUpdate, flip, shift, offset, arrow } from '@floating-ui/dom';
	import { storePopup } from '@skeletonlabs/skeleton';
	storePopup.set({ computePosition, autoUpdate, flip, shift, offset, arrow });

	import { initializeStores } from '@skeletonlabs/skeleton';
	import NavDrawer from '../lib/components/navdrawer/navdrawer.svelte';
	import Fa from 'svelte-fa';
	import { faGithub } from '@fortawesome/free-brands-svg-icons';
	import Legal from '$lib/components/misc/legal.svelte';
	import { onMount } from 'svelte';
	initializeStores();

	const drawerStore = getDrawerStore();
	const modalStore = getModalStore();

	const modalRegistry: Record<string, ModalComponent> = {
		legal: { ref: Legal }
	}

	onMount(() => {
		// Set the default modal to be open
		modalStore.trigger({
			type: "component",
			component: "legal",			
		})
	});
</script>

<main class="p-2 md:p-4 min-h-[90vh]">
	<Modal components={modalRegistry} />
	<Drawer>
		{#if $drawerStore.id === 'navdrawer'}
			<NavDrawer />
		{/if}
	</Drawer>
	<Navbar />
	<slot />
	<br /><br />
</main>
<footer class="w-full bg-tertiary-backdrop-token p-4 flex justify-between">
	<div>
		<h3 class="h3">Spotube</h3>
		<p>
			Copyright © {new Date().getFullYear()} Spotube
		</p>
	</div>
	<ul>
		<li>
			<a href="https://github.com/KRTirtho/spotube">
				<Fa class="inline mr-1" icon={faGithub} size="lg" />
				Github
			</a>
		</li>
		<li>
			<a href="https://opencollective.org/spotube">
				<img
					src="https://avatars0.githubusercontent.com/u/13403593?v=4"
					alt="OpenCollective"
					height="20"
					width="20"
					class="inline mr-1"
				/>
				OpenCollective
			</a>
		</li>
	</ul>
</footer>
