import { useEffect, useState } from "react";
import { Avatar } from "@skeletonlabs/skeleton-react";

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

const formatter = new Intl.NumberFormat('en-US', {
  style: 'currency',
  currency: 'USD',
  compactDisplay: 'short',
  maximumFractionDigits: 0
});


export function Supporters() {
  const [members, setMembers] = useState<Member[]>([]);

  useEffect(() => {
    // Fetch members data from an API or other source
    async function fetchMembers() {
      const res = await fetch('https://opencollective.com/spotube/members/all.json');
      const members = (await res.json()) as Member[];
      setMembers(
        members
          .filter((m) => m.totalAmountDonated > 0)
          .sort((a, b) => b.totalAmountDonated - a.totalAmountDonated)
      );
    };

    fetchMembers();
  }, []);


  return <div
    className="gap-4 grid"
    style={{
      gridTemplateColumns: 'repeat(auto-fill, minmax(150px, 1fr))',
      gridAutoRows: 'minmax(50px, auto)',
    }}
  >
    {
      members.map((member) => {
        return <a
          key={member.MemberId}
          href={member.profile}
          target="_blank"
          className="flex items-center gap-2 px-2 py-1 overflow-ellipsis preset-tonal-secondary rounded-lg"
        >
          <Avatar src={member.image} name={member.name} classes="w-10 h-10" />
          <div className="flex flex-col overflow-hidden">
            <p className="truncate">{member.name}</p>
            <p className="capitalize text-sm underline decoration-dotted">
              {formatter.format(member.totalAmountDonated)}
              ({member.role.toLowerCase()})
            </p>
          </div>
        </a>;
      })
    }
  </div>;
}