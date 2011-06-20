From: Zahid Chowdhury <zahid.chowdhury-VJizFkI/10gAspv4Qr0y0gC/G2K4zDHf@public.gmane.org>
Subject: RE: [ANNOUNCE] nilfs kmod 2.0.22 released
Date: Mon, 20 Jun 2011 16:23:03 -0700
Message-ID: <053D39D3D76C474EB2D2A284AA6BA3181B05E99D49@COLOSSEXCH01.starsolutions.com>
References: <20110619.202245.239001349.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110619.202245.239001349.ryusuke-sG5X7nlA6pw@public.gmane.org>
Content-Language: en-US
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello Ryusuke (and any other nilfs developers),
  My Centos 5.5 box's corrupted nilfs partition mounted with the new kernel module. Thanks all.

Zahid

-----Original Message-----
From: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Ryusuke Konishi
Sent: Sunday, June 19, 2011 4:23 AM
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: [ANNOUNCE] nilfs kmod 2.0.22 released

Hi all,

I just released nilfs-2.0.22 kernel module and made it available at:

 http://www.nilfs.org/en/download.html

This is another release of standalone module for old kernels
(2.6.18~2.6.29), which is mainly intended for centos users.

It backported recent fixes and robustness enhancements including
rollback from the previous checkpoint with spare super block, and so
forth.

Users of the old kernel module are recommended to upgrade the old one
to this version.

For datails, see the changelog on:

 http://www.nilfs.org/download/ChangeLogv2


Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
