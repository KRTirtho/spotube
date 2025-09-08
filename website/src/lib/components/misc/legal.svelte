<script lang="ts">
    import SvelteMarkdown from "svelte-markdown";
	import Layout from "$lib/components/markdown/layout.svelte";
    
    const mdContent = `
## 🚨 Spotube is banned from using "Spotify™ API" 🚨

The developer of Spotube has received a cease and desist letter from Spotify USA Inc. and Spotify AB, asserting a legal threat concerning the distribution and development of any application that utilizes Spotify’s data API in conjunction with content from YouTube® to facilitate ad-free playback of music tracks. The letter contends that this specific use of the Spotify™ APIs contravenes the Spotify™ Agreements and may also infringe upon the rights of music rights holders.

Consequently, as the official maintainer of Spotube, I will immediately cease all forms of official distribution and development of Spotube that continue to employ the aforementioned 'Spotify™ APIs'

<ins>Their exact reasoning</ins>: (any) "uses of Spotify’s data API in connection with content from YouTube to provide ad-free playback of music tracks. The use of the Spotify APIs in this manner violates the Spotify Agreements and may also violate the rights of music rights holders."

## So what's now?

> In short, we are cooked (legally)

For now, I've to:

1. Stop distributing/developing Spotube/any app that uses "Spotify™ APIs"

   That means, I can no longer distribute Spotube through the website, GitHub, any app store and immediately have to take down the versions that uses Spotify™ APIs.

1. Stop using their logo/image/name/intellectual property in a manner that "seems infringement"
1. Forever desist from aiding or assisting any other person or entity in the activities described above

---

**For the users of Spotube:**

Don't worry, Spotube is banned only from (or assisting other) using those APIs. As long as the app isn't using them or no way helps anyone else to use them, it's ok.

In future, I'll try to rewrite Spotube to ensure it operates within the bounds of copyright law and platform policies. And give ways for the users to extend the app to their use cases. Work is already in progress to implement this! So expect some big updates soon!

But for eternity, you can't download versions of Spotube that still uses "Spotify™ APIs" from official means (website/Github/app stores). Those will be taken down.

**But newer version of Spotube that _doesn't_ use "Spotify™ APIs" will be available to replace those.**

That means, in the upcoming new versions, you will no longer be able to login with your "Spotify™ Account", access your saved playlists, albums, tracks, followed artists or perform any action on that account or anything that is from "Spotify™" or owned by "Spotify™" (yes the API public data (e.g. track metadata) as well) through Spotube.

**Conclusion:** I'm extremely sorry for this disruption to your day to day music listening experience. Spotube existed and it used by a large number of users because they find it better. And we'll continue to be better than others but legally\* from now on.
`
</script>

<div class="bg-primary-100 p-5 rounded-lg overflow-scroll max-h-[95vh]">
    <Layout>
        <SvelteMarkdown source={mdContent}/>
    </Layout>
    <p class="w-1 h-60"></p>

    <p class="text-surface-500 mt-20">
		Spotube has no affiliation with Spotify™ or any of its subsidiaries.
	</p>
</div>