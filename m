From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] nilfs-utils: mkfs.nilfs2 should check presence of NILFS2 volume on device
Date: Sun, 24 Mar 2013 16:41:30 +0300
Message-ID: <91A35B7F-A668-4B57-888F-7CE2A7D0ED86@dubeyko.com>
References: <1364039122.16985.2.camel@slavad-ubuntu-12.04> <20130323.233257.27780281.konishi.ryusuke@lab.ntt.co.jp> (sfid-20130323_164140_995158_E9763CF3) <201303241309.19162.Martin@lichtvoll.de>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=T0aRhOOzpM7jhe69euvyo/X5R3r9lSPMc5OwItT4ty8=;
	b=ewctDf6m6asAIYU6m6JliHNq37Iq7ynVw+mipzHMqureA8KAMJ/Ffz3/BtMKB2UtB6zg/CV3cBGHggDIXZrgwJCtVp/TSzIs6gq7hM7F5r2A1DdCjHPoDCN9mdBE+C0o;
In-Reply-To: <201303241309.19162.Martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Martin Steigerwald <Martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hendrik-j5CO6tLloWodnm+yROfE0A@public.gmane.org

Hi Martin,

On Mar 24, 2013, at 3:09 PM, Martin Steigerwald wrote:

> Hi!
>=20
> Am Samstag, 23. M=E4rz 2013 schrieb Ryusuke Konishi:
>> On Sat, 23 Mar 2013 15:45:22 +0400, Vyacheslav Dubeyko wrote:
>>> From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
>>> Subject: [PATCH] nilfs-utils: mkfs.nilfs2 should check presence of
>>> NILFS2 volume on device
>>>=20
>>> The mkfs.nilfs2 utility should check presence of NILFS2 volume on
>>> device and to warn a user about possibility to destroy data by mkfs
>>> activity. This patch tries to read and to validate checksums of
>>> primary and secondary superblocks on opened device. If this operati=
on
>>> ends successfully then mkfs.nilfs2 informs a user about potential
>>> danger to destroy existing NILFS2 volume. The execution of mkfs.nil=
fs2
>>> stops with offering to make decision about continuation or abortion=
 of
>>> operation. However, if a user runs mkfs.nilfs2 with "-q" option the=
n
>>> checking of NILFS2 volume is skipped.
>>>=20
>>> Reported-by: Hendrik Levsen <hendrik-j5CO6tLloWodnm+yROfE0A@public.gmane.org>
>>> Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
>>> Tested-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
>>=20
>> This patch breaks compatibility of mkfs.nilfs2 in the case when user=
s
>> or tools are expecting overwrite an exisiting partition.  However, I
>> am inclined to accept this kind of protection feature.
>>=20
>> One thing disturbing is that "quiet option" is used to turn off the
>> protection; "quiet option" is just an option to suppress messages.
>>=20
>> Please consider adding "force overwrite (-f)" option like
>> mkfs.xfs.
>=20
> Also please consider adding of other filesystems via blkid just as mk=
fs.xfs=20
> and since a short time also mkfs.btrfs does.
>=20

Sorry, I don't fully understand about mkfs.btrfs. Could you describe in=
 more details what you mean?

Thanks,
Vyacheslav Dubeyko.

> I agree on "-f" being a suitable option for force formatting the volu=
me.
>=20
> Thanks,
> --=20
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
