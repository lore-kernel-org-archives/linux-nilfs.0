From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Tue, 23 Oct 2012 13:26:35 +0400
Message-ID: <1350984395.2041.32.camel@slavad-ubuntu>
References: <20121012103119.GF27763@wloczykij>
	 <1350040053.2026.47.camel@slavad-ubuntu> <20121012114043.GG27763@wloczykij>
	 <26EBDBC2-8938-41BC-8C0C-6F6F3A0FD1EC@dubeyko.com>
	 <20121014200836.GK27763@wloczykij> <1350281888.2488.9.camel@slavad-ubuntu>
	 <20121018201528.GS27763@wloczykij> <1350628991.2028.25.camel@slavad-ubuntu>
	 <20121019101421.GT27763@wloczykij> <1350973913.2041.25.camel@slavad-ubuntu>
	 <20121023084100.GW27763@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=ESzdq5dFiqhJFDtOUiIq5vzYNL9JeJQSur7BH7rOTj8=;
	b=UdLMzT8wH3seZrFc47B6Ns0hcHh6q6P+CGqtDY6vh3lKVMGuUOcrDRF+CA66203OkKW3xgz9RyZlAstNz0ZvBUe7+q8vAHCJHNSFwpl3S5O//VqGgAj2eC6VizkR0xfc;
In-Reply-To: <20121023084100.GW27763@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 2012-10-23 at 10:41 +0200, Piotr Szymaniak wrote:
> On Tue, Oct 23, 2012 at 10:31:53AM +0400, Vyacheslav Dubeyko wrote:
> > Sorry, for delay with answer. I was slightly busy.
> 
> Hi,
> 
> Not a problem. Thanks for help. (:
> 
> 
> > So, currently, I have such picture. Your initial report was:
> > 
> > On Tue, 2012-10-09 at 00:25 +0200, Piotr Szymaniak wrote:
> > > dmesg shows:
> > > (...)
> > > [43893.754525] segctord starting. Construction interval = 300 seconds, CP frequency < 30 seconds
> > > [43893.760245] NILFS: corrupt root inode.
> > 
> > This error message generates only in one place by
> > nilfs_get_root_dentry() method in super.c
> > (http://lxr.free-electrons.com/source/fs/nilfs2/super.c#L903):
> > 
> > 903         if (!S_ISDIR(inode->i_mode) || !inode->i_blocks || !inode->i_size) {
> > 904                 iput(inode);
> > 905                 printk(KERN_ERR "NILFS: corrupt root inode.\n");
> > 906                 ret = -EINVAL;
> > 907                 goto out;
> > 908         }
> > 
> > So, only corruption of any of three fields of inode can be a reason for
> > such error message, from my understanding. But from the dump of #734205
> > block I can see such content of root inode (ino = 2):
> > 
> > 00000100  01 00 00 00 00 00 00 00  00 10 00 00 00 00 00 00  |................|
> > 00000110  08 00 00 00 00 00 00 00  08 00 00 00 00 00 00 00  |................|
> > 00000120  03 5a 62 02 03 5a 62 02  00 00 00 00 00 00 00 00  |.Zb..Zb.........|
> > 00000130  ed 41 13 00 00 00 00 00  00 00 00 00 00 00 00 00  |.A..............|
> > 00000140  8f aa 0a 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > 00000150  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > 00000160  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > 00000170  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > 
> > [00000100] i_blocks = 0x1
> > [00000108] i_size = 0x1000
> > [00000130] i_mode = 0x41ed (040755)
> > 
> > It means that inode's content is placed in one block and this inode
> > describes folder. So, the on-disk inode is correct and should be read
> > correctly during mounting. I have compared vanilla kernel code with
> > https://github.com/raspberrypi/linux and can't see any significant
> > difference. Currently, I think that unstable functioning of SD-card
> > controller in the Turbo mode can be the reason of this error message but
> > maybe I haven't the clear picture.
> > 
> > Did you try to mount this NILFS2 volume on host machine in normal mode?
> > Do you have such error message with this NILFS2 volume in another
> > technical environment?
> 
> Yes, I tried to run it in normal mode (/boot is on small fat partition,
> so I can tweak Turbo one way on another without touching rootfs). Also
> all of the dumps are made on another machine (Gentoo x86 with kernel 3.6.2)
> and it refuses to mount with above message.
> 

It is strange. Did you try to mount NILFS2 volume that is placed on
SD-card for the case of on another machine (Gentoo x86 with kernel
3.6.2)?

Could you try to mount volume's dump as loop device on machine (Gentoo
x86 with kernel 3.6.2)?

Could you share strace output (strace mount <device> <mount-point>) for
the case of mount trying?

With the best regards,
Vyacheslav Dubeyko.

> 
> Piotr Szymaniak.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
