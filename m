From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Tue, 27 Nov 2012 20:43:01 +0300
Message-ID: <295B3FE7-A44E-4D57-9A6A-B725EF1BA9EB@dubeyko.com>
References: <50A5737C.2040805@li.ru> <201211160313.AA04185@capsicum.lab.ntt.co.jp> <50A65588.3000205@li.ru> <CAKFNMomO6ebYkXk=A9H2Wieswvogt6dj16Otj0u74M4aHOOPBg@mail.gmail.com> <20121127151924.GW4028@wloczykij>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=uwHzq20UV885v5BdPd7Bidn7V1FTdjG41CvV5OoTKfs=;
	b=AAcy/jGcwbNVyfwRDgWjhjRf+x4dtF3b0C5p1Nvd1cYA6flCrbfL5Pg3MN5pdXzftst8RnRcm8O4LOAUu86dGSHKFB2Pc65Av0llgIGIR2nZZasv5fyWZDifd1KvBW0U;
In-Reply-To: <20121127151924.GW4028@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, fwdnilfsml.to.11df-2pMamKoQTv4@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Nov 27, 2012, at 6:19 PM, Piotr Szymaniak wrote:

> On Sat, Nov 17, 2012 at 10:27:36AM +0900, Ryusuke Konishi wrote:
>> On Sat, Nov 17, 2012 at 12:02 AM,  <fwdnilfsml.to.11df-2pMamKoQTv4@public.gmane.org> wro=
te:
>>>> Hmm, the default value of this parameter is zero.
>>>> Have you changed it with the nilfs-tune tool by some chance ?
>>>=20
>>> Yes, I've changed it to 60 sec for rootfs partition, and 180 sec fo=
r data
>>> partition. It worked flawlessly with this setup on root partition f=
or last
>>> 14 months...
>>=20
>> OK, please confirm version of your all kernels including initrd.
>=20
> As I got this issue here's some info:
> (nilfs_cleanerd_rootfs.conf that I'm using for rootfs)
> protection_period       3600
> min_clean_segments      15%
> max_clean_segments      25%
> clean_check_interval    10
> selection_policy        timestamp       # timestamp in ascend order
> nsegments_per_clean     2
> mc_nsegments_per_clean  4
> cleaning_interval       5
> mc_cleaning_interval    1
> retry_interval          60
> use_mmap
> log_priority            info
>=20
> maszn ~ (: uname -srm
> Linux 3.6.4 i686
>=20
> maszn ~ (: eix nilfs-utils -c
> [I] sys-fs/nilfs-utils (2.1.4-bwmKdHsBrCaKN0S5hHIosQ@public.gmane.org): *snip*
>=20
> What's the next step to debug this issue?
>=20

Could you describe the path of issue reproducing? What filesystem opera=
tions took place near before the issue?

With the best regards,
Vyacheslav Dubeyko.

> Piotr Szymaniak.
> --=20
> Jedna z g=C5=82=C3=B3w  Zaphoda spojrza=C5=82a w bok.  Druga  zrobi=C5=
=82a  zaraz to samo,
> gdy=C5=BC  chcia=C5=82a zobaczy=C4=87,  na co patrzy pierwsza,  nie b=
y=C5=82o to jednak nic
> konkretnego.
>  -- Douglas Adams, "The Hitchhiker's Guide to the Galaxy"

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
