From: Philippe CHATAIGNON <liste-ZXOCcuNttmoBe96aLqz0jA@public.gmane.org>
Subject: Re: Bug : reuse same inode
Date: Sat, 19 Feb 2011 16:26:09 +0100
Message-ID: <20110219162609.6d9318fa@micro24>
References: <20110210233201.6e8d711d@micro24>
	<20110218.162145.57461053.ryusuke@osrg.net>
	<20110218205739.26dde3b8@micro24>
	<20110219.222232.05855196.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110219.222232.05855196.ryusuke-sG5X7nlA6pw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

> I found GC never causes such interference.  So, the inode corruption
> was not caused neither by the snapshot mount nor GC.
>=20
> Now, I'm suspecting a race condition between the removal of
> "f3_20110123_223247.ts" and creation of
> "f5_20110125_202053.ts(0).Xcl".
>=20
> Even though "f3_20110123_223247.ts" was removed at cp14522 (2011-01-2=
5
> 20:29:09) from the "capture" directory, it seems like actual removal
> of the inode happened a bit later than that since the file size was
> pretty big.

On my computer, deletion of a .ts file takes ~ 4-6 seconds (~1s/1G).
It may happend that a *.Xcl file is created during this time.

I make a little test with that fs. During the deletion of the file
f3_20110107_205154.ts (inode 16), in a another console, I touch
a file about every second :

The result :
19 -rw-r--r-- 1 philippe users    0 19 f=E9vr. 14:54 test1
20 -rw-r--r-- 1 philippe users    0 19 f=E9vr. 14:54 test2
22 -rw-r--r-- 1 philippe users    0 19 f=E9vr. 14:55 test3
23 -rw-r--r-- 1 philippe users    0 19 f=E9vr. 14:55 test4
16 -rw-r--r-- 1 philippe users    0 19 f=E9vr. 14:55 test5

test1, 2, 3, 4 were created instantaneously while the ts file was
deleting. But not test5 : touch command waits ~ 2-3 seconds until the r=
m
was finished on the other console. It has the same inode that the
deleted file. At final, filesystem seems OK but this time zone where
the created file reuse the old inode during a file deletion seems a goo=
d
candidate for race condition.

I ask myself : is it mandatory to reuse inode number in nilfs design ?=20

> OK, but, please resend me the checkpoint list you pasted last week
> before reusing the disk.  The list looks like expired on the web
> (sorry, it's missing on my PC).

Here is the same checkpoint list that I pasted last week (not the
actual) with no expiration time : http://dpaste.org/UmEb/

In fact, I will keep this partition and continue to use it. So I delete
the 2 files that share the same inode (cf. my first mail). For the 2nd
rm, I have the message :
NILFS warning (device dm-0): nilfs_do_unlink: deleting nonexistent file
(14), 0

I touch some files after that :
14 -rw-r--r-- 1 philippe users    0 19 f=E9vr. 14:58 test6
24 -rw-r--r-- 1 philippe users    0 19 f=E9vr. 14:58 test7
25 -rw-r--r-- 1 philippe users    0 19 f=E9vr. 14:59 test8

=46ilesystem seems OK and I will send a new mail if new trouble appears=
=2E
Thanks for your help,

Regards,

PhC
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
