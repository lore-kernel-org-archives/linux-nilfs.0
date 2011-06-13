From: Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>
Subject: mount & fsck of nilfs partition fail.
Date: Mon, 13 Jun 2011 00:13:17 -0700
Message-ID: <053D39D3D76C474EB2D2A284AA6BA3181B05E4E02D@COLOSSEXCH01.starsolutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,
  We had another crash with nilfs2 under load and then on reboot mount failed as usual on
    "Checksum error in segment payload"
Leter when we tried an "fsck0.nilfs2 -v -f" on the partition we got:
.
.
.
Unclean FS.
The latest log is lost. Trying rollback recovery..
.
Searching the latest checkpoint.
fsck0.nilfs2: cannot read block (blocknr = 2696911)

and fsck0.nilfs2 gave up. Is there any other way of recovering this partition? If so, how?

Is this problem common? Is there any way to stop this scenario from occurring? Thanks.

Zahid
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
