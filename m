From: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Subject: NiLFS support on Pinebook
Date: Wed, 26 Feb 2020 11:22:35 +0100
Message-ID: <20200226102235.GA2060@dropje.13thmonkey.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Dear folks, dear Ryusuke,

I am trying to use NiLFS2 on my Pinebook that identifies itself as GNU/Linux
on aarch64. It allows me to install nilfs-tools wich seem to work fine but
when i mount a partition it gives the error "mount.nilfs2: cannot find or load
nilfs2 filesystem". Does this mean the linux kernel has no nilfs2 module
shipped with it, but only the tools?

How can I install the nilfs2 filesystem? Or is that up to the distribution and
out of my control?

With regards,
Reinoud

