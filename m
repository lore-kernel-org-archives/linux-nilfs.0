From: Philippe CHATAIGNON <liste-ZXOCcuNttmoBe96aLqz0jA@public.gmane.org>
Subject: Re: Bug : reuse same inode
Date: Fri, 18 Feb 2011 20:57:39 +0100
Message-ID: <20110218205739.26dde3b8@micro24>
References: <20110208213237.0a0bef59@micro24>
	<20110210.140105.33383103.ryusuke@osrg.net>
	<20110210233201.6e8d711d@micro24>
	<20110218.162145.57461053.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110218.162145.57461053.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Le Fri, 18 Feb 2011 16:21:45 +0900 (JST),
Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> a =E9crit :
> Thank you for the cooperation.
>=20
> Yeah, this file is exactly the file that overrode
> "f5_20110125_202053.ts(0).Xcl" at cp15731.
>=20
> I don't know why the past inode overrode the latest inode.  One
> possible explanation is that garbage collection caused this
> interference, and another is interference by a snapshot mount for the
> checkpoint 14444.
>=20
> Were you mounting the snapshot cp14444 when
> "f5_20110125_202053.ts(0).Xcl" was destroyed at cp15731 ?
>=20
> If not, dummy on-memory inodes used for the garbage collection seem
> suspicious to me.

Hi,
the first time I used snapshot on this fs is when I lost a file
because of inode's reuse (my first mail). When file f5_...Xcl was
deleted at cp15731, cp14444 was not a ss and wasn't mounted. And there
were no ss on this fs (only cp).

Tell me if you need additional information. This partition's size is
200G and I'll need that space in a few days.

Regards,

PhC
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
