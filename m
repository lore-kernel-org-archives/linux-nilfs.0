From: =?UTF-8?Q?=C5=81ukasz_W=C3=B3jcicki?= <lwojcicki-V+nj596LuoKHKKo6LODCOg@public.gmane.org>
Subject: Re: Limits for checkpoints
Date: Fri, 09 Jul 2010 18:16:21 +0200
Message-ID: <1278692181.7532.1.camel@Stanowisko-25>
References: <1278652414.8104.3.camel@Stanowisko-25>
	 <87eifd9q88.wl%jir@sekiba.com> <1278653914.8104.7.camel@Stanowisko-25>
	 <20100709.200552.176154048.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100709.200552.176154048.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


> If you worry about the disk usage of df output, one of the way is
> adjusting min_clean_segments and max_clean_segments in
> /etc/nilfs_cleanerd.conf.
>=20
> In the latest version of nilfs, nilfs_cleanerd tries to store past
> data until free space gets less than 10% of the disk capacity.
>=20
> By decreasing those parameters, or by setting min_clean_segments to
> zero this behavior is adjustable.

Are these parameters will work with the version of kernel module
2-0-18 ?

Regards,
=C5=81ukasz W=C3=B3jcicki

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
