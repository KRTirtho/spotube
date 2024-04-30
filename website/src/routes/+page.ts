interface Member {
	MemberId: number;
	createdAt: string;
	type: string;
	role: string;
	isActive: boolean;
	totalAmountDonated: number;
	currency?: string;
	lastTransactionAt: string;
	lastTransactionAmount: number;
	profile: string;
	name: string;
	company?: string;
	description?: string;
	image?: string;
	email?: string;
	twitter?: string;
	github?: string;
	website?: string;
	tier?: string;
}

export const load = async () => {
	const res = await fetch('https://opencollective.com/spotube/members/all.json');
	const members = (await res.json()) as Member[];

	return {
		props: {
			members: members
				.filter((m) => m.totalAmountDonated > 0)
				.sort((a, b) => b.totalAmountDonated - a.totalAmountDonated)
		}
	};
};
