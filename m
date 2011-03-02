From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] nilfs2: record used amount of each checkpoint in
 checkpoint list
Date: Wed, 02 Mar 2011 10:49:15 +0900 (JST)
Message-ID: <20110302.104915.53416445.ryusuke@osrg.net>
References: <1298740431-13749-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<201103011305.43120.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201103011305.43120.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Tue, 1 Mar 2011 13:05:42 +0100, dexen deVries wrote:
> Hello,
> 
> 
> On Saturday 26 of February 2011 18:13:51 you wrote:
> > This records the number of used blocks per checkpoint in each
> > checkpoint entry of cpfile.  Even though userland tools can get the
> > block count via nilfs_get_cpinfo ioctl, it was not updated by the
> > nilfs2 kernel code.  This fixes the issue and makes it available for
> > userland tools to calculate used amount per checkpoint.
> > 
> > Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
> > ---
> >  (...snip...)
> 
> 
> I've applied this this patch and the two recent userpace patches and it works 
> alright, with one surprise -- two suspiciously large BLKCNT:
> 
> $ lscp -b
> (...snip...)
>               270584  2011-03-01 12:52:57   cp    -           33     248244
>               270585  2011-03-01 12:53:01   cp    -           34     248245
>               270586  2011-03-01 12:53:06   cp    - 18446744073709550523     
> 248245
>               270587  2011-03-01 12:53:11   cp    - 18446744073709550550     
> 248257
>               270588  2011-03-01 12:53:15   cp    -         1268     248247
>               270589  2011-03-01 12:53:16   cp    -         1803     248246
>               270590  2011-03-01 12:53:21   cp    -         4952     248256
> (...snip...)
> 
> 
> It is possible the two strange checkpoints (270586 & 7) were created with new 
> userland and old kernel, before reboot.
> 
> Do you want me to provide any extra info on it or just let it slip?

Seems like underflow happened.

Did you format the partition with the latest (not yet released)
mkfs.nilfs2 tools?

Thanks,
Ryusuke Konishi
 
> -- 
> dexen deVries
> 
> [[[↓][→]]]
> 
> > how does a C compiler get to be that big? what is all that code doing?
> 
> iterators, string objects, and a full set of C macros that ensure
> boundary conditions and improve interfaces.
> 
> ron minnich, in response to Charles Forsyth
> 
> http://9fans.net/archive/2011/02/90
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
