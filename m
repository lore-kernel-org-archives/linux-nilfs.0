From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Bug : reuse same inode
Date: Sat, 19 Feb 2011 22:22:32 +0900 (JST)
Message-ID: <20110219.222232.05855196.ryusuke@osrg.net>
References: <20110210233201.6e8d711d@micro24>
	<20110218.162145.57461053.ryusuke@osrg.net>
	<20110218205739.26dde3b8@micro24>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110218205739.26dde3b8@micro24>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-8859-1"
To: liste-ZXOCcuNttmoBe96aLqz0jA@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

Hi,
On Fri, 18 Feb 2011 20:57:39 +0100, Philippe CHATAIGNON wrote:
> Le Fri, 18 Feb 2011 16:21:45 +0900 (JST),
> Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org> a =E9crit :
> > Thank you for the cooperation.
> >=20
> > Yeah, this file is exactly the file that overrode
> > "f5_20110125_202053.ts(0).Xcl" at cp15731.
> >=20
> > I don't know why the past inode overrode the latest inode.  One
> > possible explanation is that garbage collection caused this
> > interference, and another is interference by a snapshot mount for t=
he
> > checkpoint 14444.
> >=20
> > Were you mounting the snapshot cp14444 when
> > "f5_20110125_202053.ts(0).Xcl" was destroyed at cp15731 ?
> >=20
> > If not, dummy on-memory inodes used for the garbage collection seem
> > suspicious to me.
>=20
> Hi,
> the first time I used snapshot on this fs is when I lost a file
> because of inode's reuse (my first mail). When file f5_...Xcl was
> deleted at cp15731, cp14444 was not a ss and wasn't mounted. And ther=
e
> were no ss on this fs (only cp).

I found GC never causes such interference.  So, the inode corruption
was not caused neither by the snapshot mount nor GC.

Now, I'm suspecting a race condition between the removal of
"f3_20110123_223247.ts" and creation of
"f5_20110125_202053.ts(0).Xcl".

Even though "f3_20110123_223247.ts" was removed at cp14522 (2011-01-25
20:29:09) from the "capture" directory, it seems like actual removal
of the inode happened a bit later than that since the file size was
pretty big.

> Tell me if you need additional information. This partition's size is
> 200G and I'll need that space in a few days.

OK, but, please resend me the checkpoint list you pasted last week
before reusing the disk.  The list looks like expired on the web
(sorry, it's missing on my PC).


Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
