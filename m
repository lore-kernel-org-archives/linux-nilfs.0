From: Anton Eliasson <devel-17Olwe7vw2dLC78zk6coLg@public.gmane.org>
Subject: Re: Broken nilfs2 filesystem
Date: Wed, 12 Jun 2013 22:12:25 +0200
Message-ID: <51B8D629.4070301@antoneliasson.se>
References: <1369809573.2253.31.camel@slavad-ubuntu> <20130529.233757.27789741.konishi.ryusuke@lab.ntt.co.jp> <1369894385.2255.8.camel@slavad-ubuntu> <20130530.155543.480320022.konishi.ryusuke@lab.ntt.co.jp> <1370501769.2202.36.camel@slavad-ubuntu> <20130606092054.GA201@diablo.13thmonkey.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130606092054.GA201-HNv6YvNvQKMNqjISwOrxaLFspR4gePGN@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Reinoud Zandijk skrev 2013-06-06 11:20:
> Hi,
>
> just my $0.02 so to say:
>
> On Thu, Jun 06, 2013 at 10:56:09AM +0400, Vyacheslav Dubeyko wrote:
>> First of all, unfortunately, I can't reproduce the issue yet, curren=
tly.
>> I suspect that in this issue the aging state of volume, peculiarity =
of
>> workload and environment play very important role. As I remember, al=
l
>> reporters of likewise symptoms (broken bnode error messages) talked
>> about several months of successful working of NILFS2 file system.
> sounds to me as if a b-tree is in a perculiar state and that updating=
 the
> btree results in this corruption.
>
> Have you tried to mount one of the checkpoints/snapshots earlier as R=
O and see
> if those are correct? If so, dumping both DATs and both btrees might =
give a
> clue as to what went wrong. If only it gives a clue as to how complic=
ated the
> btree is before the updating and what actions are taken on it.
>
> With regards,
> Reinoud
>
I have configured nilfs_cleanerd.conf to clean very aggressively so my=20
earliest checkpoint is from after the incident. I included the contents=
=20
of that file in my first email sent on May 22=20
(http://article.gmane.org/gmane.comp.file-systems.nilfs.user/2920).

Even so, I tried to loopback mount the oldest checkpoint I have which I=
=20
found was affected by the same corruption.

# losetup /dev/loop0 /Athena/Dump/riven/riven-home-20130531.img
# mount /dev/loop0 /mnt
$ mount | tail -1
/dev/loop0 on /mnt type nilfs2 (ro,relatime,norecovery)
$ lscp /dev/loop0
                  CNO        DATE     TIME  MODE  FLG NBLKINC       ICN=
T
              1260571  2013-05-23 16:51:49   cp    -          140 15549=
6
              1260572  2013-05-23 16:51:51   cp    -         1632 15549=
5
              1260575  2013-05-23 16:52:06   cp    -         1473 15549=
6
              1260576  2013-05-23 16:52:09   cp    -           49 15549=
5
              1260580  2013-05-24 23:36:11   cp    -         1345 15549=
6
              1260581  2013-05-24 23:36:16   cp    -         1500 15549=
5
              1260582  2013-05-24 23:36:21   cp    -         1356 15549=
7
              1260583  2013-05-24 23:36:26   cp    -         1465 15549=
5
# chcp ss /dev/loop0 1260571
# umount /mnt
# mount -o ro,norecovery,cp=3D1260571 /dev/loop0 /mnt
$ cd /mnt/anton/Bilder/20130321-28\ Jakobs\ bilder\ fr=E5n\ Nederl=E4nd=
erna
$ LANG=3DC cat *>/dev/null
cat: 160.JPG: Input/output error
cat: 163.JPG: Input/output error
cat: 164.JPG: Input/output error
cat: 165.JPG: Input/output error
cat: 170.JPG: Input/output error
cat: 172.JPG: Input/output error
cat: 179.JPG: Input/output error

--=20
Best Regards,
Anton Eliasson

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
