<script lang="ts">
	import '../app.postcss';
	import Navbar from '../components/navbar/navbar.svelte';

	// Highlight JS
	import hljs from 'highlight.js/lib/core';
	import 'highlight.js/styles/github-dark.css';
	import { Drawer, getDrawerStore, storeHighlightJs } from '@skeletonlabs/skeleton';
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
	import NavDrawer from '../components/navdrawer/navdrawer.svelte';
	initializeStores();

	const drawerStore = getDrawerStore();
</script>

<main class="p-2 md:p-4 flex flex-col">
	<Drawer>
		{#if $drawerStore.id === 'navdrawer'}
			<NavDrawer />
		{/if}
	</Drawer>
	<Navbar />
	<slot />
</main>
