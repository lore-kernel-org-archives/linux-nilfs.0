From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: searching checkpoints contaning an inode (or a filename)
Date: Sat, 6 Jul 2013 12:17:18 +0400
Message-ID: <27C67ADF-F87A-4F43-9F53-82BD29EE748E@dubeyko.com>
References: <20130705201701.GE23851@taesoo.org> <CALJXSJrLo_5=e-M41vXyuS9SbRyeZ=zjLYv2Hs3a8Dt+BwS6ig@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=NmX1SmciQoz0xog6Z9f487tmm9vbah0E/iunUiXRZT8=;
	b=Ea+d+1Ha26qtsXMWI6hL4+IaMQK/FIWe7bhqsG6nZkWojItjBmCGugjx8NYvT1RPrTG3nqJvQkyaU9vAGqMwVRKYYIM2vMzBlN9kw6oZ3Ieyd043oGXdPvt9wWvHFo89;
In-Reply-To: <CALJXSJrLo_5=e-M41vXyuS9SbRyeZ=zjLYv2Hs3a8Dt+BwS6ig-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Taesoo Kim <taesoo-3s7WtUTddSA@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, slava-2lV3ebY47BVBDgjK7y7TUQ@public.gmane.org

Hi J=E9r=F4me,

On Jul 6, 2013, at 1:48 AM, J=E9r=F4me Poulin wrote:

> On Fri, Jul 5, 2013 at 4:17 PM, Taesoo Kim <taesoo-3s7WtUTddSA@public.gmane.org> wrote:
>>=20
>> q3. using nilfs as rootfs?
>> (I couldn't find any people using nilfs for rootfs. Are there any
>> issue on that? or just matter of performance? on updates for
>> example)
>=20
> I'm using NILFS as root filesystem on my work laptop for a total of 4
> years. I switched to BTRFS for a year in between but looking at how
> fast it kills SSD, it wass not worthwhile.
>=20
> Stability wise, I only had 2 problems with NILFS, the first, which wa=
s
> fixed promptly, caused a total data lost because of how the cleaner
> scrub the disk (using the time), it scrubbed data from the future
> after time ran backward. Then the other problem was a kernel OOPS
> about a file from the debian APT cache, I deleted it and it runs just
> fine now, I couldn't take the backtrace.
>=20

Could you share more details about the issue? I need to understand
the reproducing path of the issue more clear. Can you reproduce it agai=
n?=20

Thanks,
Vyacheslav Dubeyko.

> Performance wise, on SSD the filesystem is really fast and snappy,
> while on HDD, reads are really slow, booting takes 2 minutes instead
> of less than 10 seconds, however, once booted and everything is in
> cache, it is quite fast. Database loads, especially reads on HDD is
> the worst for NILFS.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
