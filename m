From: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>
Subject: Qemu (Re: NiLFS support on Pinebook)
Date: Fri, 28 Feb 2020 11:55:03 +0100
Message-ID: <20200228105503.GA345@dropje.13thmonkey.org>
References: <20200226102235.GA2060@dropje.13thmonkey.org>
 <20200227.001457.2102675267682326035.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200227.001457.2102675267682326035.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Reinoud Zandijk <reinoud-qavaossjCcEdnm+yROfE0A@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Feb 27, 2020 at 12:14:57AM +0900, Ryusuke Konishi wrote:
> Hi Reinoud,
> 
> > when i mount a partition it gives the error "mount.nilfs2: cannot find or load
> > nilfs2 filesystem". Does this mean the linux kernel has no nilfs2 module
> > shipped with it, but only the tools?
> 
> We see this message if nilfs2 kernel module (nilfs2.ko) doesn't exists in
> /lib/modules/$(uname -r)/... .
> 
> Some distros don't have nilfs2 module (e.g. RHEL/CentOS), and some
> need an extra package like kernel-modules-extra (e.g. Fedora).
> 
> I don't know that is there in the Pinebook.

Problem with pinebook is that there are distro's around to test but they seem
to like the 3.10 kernel too much and update all but the kernel. The linux
headers they ship are for 4.x and 5.x so no use for compiling the kernel
module itself.

Can you recommend a lightweigth linux distro with nilfs support that runs fast
in `unaided' Qemu?  I.e. with only the `tcg' acceleration and with no
graphics?

Thanks in advance,
Reinoud

