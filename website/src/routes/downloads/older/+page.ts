import type { PageLoad } from "./$types";
import { Octokit } from "@octokit/rest";

const github = new Octokit();
export const load: PageLoad = async () => {
	const { data: releases } = await github.repos.listReleases({
		owner: "KRTirtho",
		repo: "spotube",
	});

	return {
		releases,
	};
};
