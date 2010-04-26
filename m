From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: grub2 now supports nilfs2!
Date: Tue, 27 Apr 2010 02:11:00 +0900 (JST)
Message-ID: <20100427.021100.238677958.ryusuke@osrg.net>
References: <878w8bfpvh.wl%jir@sekiba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <878w8bfpvh.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Mon, 26 Apr 2010 01:39:30 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> Hi,
> 
> I'd like to announce that grub2 now supports nilfs2.
> It is still early version and does not include roll forwarding mechanism,
> however it can boot kernel from nilfs2 partition when it's clean.
>
> It may still take time that any distro package reflects the changes,
> but you can try it from bzr repository without any patches.
> 
> grub2 bzr repository is following
> http://bzr.savannah.gnu.org/r/grub/trunk/grub
> 
> grub wiki
> http://grub.enbug.org/FrontPage

Congratulations and thanks!

I'm eager that this achievement gets available on distro packages.

So far, the grub2 module is operating on my laptop without any trouble.
Very nice.

Probably this roll forwarding doesn't need to implement all recovery
features supported with nilfs.

It seems enough if it can find out the latest log having a valid super
root block.  It needs to validate each log with checksums and sequence
numbers, but that's just about it.

Thank you again for your effort.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
