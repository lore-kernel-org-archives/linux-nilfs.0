From: Bryce Gibson <bryce-Ra7CeWMrBuQyzzc7d281ts/53G5R+iW0@public.gmane.org>
Subject: Corrupt root inode
Date: Mon, 24 Jun 2013 13:19:48 +1000
Message-ID: <1372043988.4304.140661247622873.2030B278@webmail.messagingengine.com>
Reply-To: bryce-Ra7CeWMrBuQyzzc7d281ts/53G5R+iW0@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=
	messagingengine.com; h=message-id:from:to:mime-version
	:content-transfer-encoding:content-type:reply-to:subject:date;
	 s=smtpout; bh=HiVSOEGvlJlRE/iBKzY9aO1v8Is=; b=hP+18bEUCCxYiKLtY
	JQlm56ZrdpPTKjqJWwWGgFs3Hpmzam4VB4JOn66lOzHiVRlKwyuGLTNBDnnBsY/8
	0Kzf3wloo+ZKY+40L78fr9N4CUV3+kuXbqjXJg+Qvhfxnf60QZ90VtGT5k3niXxO
	AXDzGXmgbdHEEOW0P9VvpAVR0w=
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi :-)

I have a root nilfs partition that appears to have been corrupted.

When I try to mount the partition - either on boot or with a liveusb -
I'm getting "NILFS: corrupt root inode".

I don't believe anything too exciting happened on the last shutdown, bu=
t
it's entirely possible that the umount/sync command didn't execute
correctly.

I've tried mounting with with two kernels, being 3.9 and 3.9.4

In the first case nilfs is built in, in the second it's a module.

This is an x86_64 laptop.

I was hoping someone might be able to offer some help with trying to
recover the partition :-)

I'm happy to provide any useful info from the drive :-)

Cheers :-)
Bryce



nilfs-tune -l /dev/loop4
--------------------------
nilfs-tune 2.1.5
=46ilesystem volume name:  =A0(none)
=46ilesystem UUID:         =A0fb7fe0c7-f6ef-44e9-8fd7-0125801e5f36
=46ilesystem magic number: =A00x3434
=46ilesystem revision #:   =A02.0
=46ilesystem features: =A0 =A0 =A0(none)
=46ilesystem state:        =A0valid
=46ilesystem OS type:      =A0Linux
Block size:              =A04096
=46ilesystem created:      =A0Fri Aug 17 00:26:09 2012
Last mount time:         =A0Sat Jun 22 04:18:22 2013
Last write time:         =A0Sun Jun 23 01:00:59 2013
Mount count:             =A0691
Maximum mount count:     =A050
Reserve blocks uid:      =A00 (user root)
Reserve blocks gid:      =A00 (group root)
=46irst inode:             =A011
Inode size:              =A0128
DAT entry size:          =A032
Checkpoint size:         =A0192
Segment usage size:      =A016
Number of segments:      =A0269
Device size:             =A02264924160
=46irst data block:        =A01
# of blocks per segment: =A02048
Reserved segments %:     =A05
Last checkpoint #:       =A0373808
Last block address:      =A0405504
Last sequence #:         =A0568326
=46ree blocks count:       =A073728
Commit interval:         =A00
# of blks to create seg: =A00
CRC seed:                =A00x44983069
CRC check sum:           =A00xced8962d
CRC check data size:     =A00x00000118

--=20
  Bryce Gibson
  bryce-Ra7CeWMrBuQyzzc7d281ts/53G5R+iW0@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
