From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Corrupted nilfs2 volume
Date: Tue, 19 Mar 2013 12:06:52 +0400
Message-ID: <1363680412.2229.14.camel@slavad-ubuntu>
References: <20130315024019.7DC1BD00@mail.dragonworks.ru>
	 <1363328491.2078.21.camel@slavad-ubuntu> <20130315232157.GC1542@black>
	 <70219EF1-8083-4DD5-BA18-84CD1914DC3E@dubeyko.com>
	 <20130318142352.GA4148@black>
	 <4E5BDA60-7615-4F82-AC0F-4459DD9EF544@dubeyko.com>
	 <20130318223145.GA17965@black>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=0BziClNgynBIAv4Ia3kEJ6MxFyCAb6SPZywE634EMMs=;
	b=fw95qCVNCrqJTH/w5fM4guPTDDjhFj3LnCkvRbZoVbVLhEVzwwAQYVrigNEe5a7NSlupz7tjYlKLxRW5q/10jFhG8VxKswg8WT+YurRBVKKCPGhEmnTv3UJKkOLfIe0X;
In-Reply-To: <20130318223145.GA17965@black>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexander Bezrukov <nilfs-issues-tvrqcU/I3+LBxmVkcvZ8vQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Alexander,

On Tue, 2013-03-19 at 02:31 +0400, Alexander Bezrukov wrote:

[snip]
> 
> > So, I need in raw dump of three segments #23443 (ss_seq = 305301,
> > first block #48011264), #23444 (ss_seq = 305302, first block
> > #48013312), #23445 (ss_seq = 305303, first block #48015360).
> > Please, make raw dump from #48011264 till #48017408 (namely,
> > 6144 blocks)
> 
> A small note: 48017408-48011264+1 = 6145
> 
> > and share with me. Moreover, please, share dumpseg output
> > for this segments.
> 
> I prepared the dumpseg output for these segments. Please find it
> at http://www.dragonworks.ru/nilfs2/dumpseg.log .
> 

Thank you for dumpseg output.

> As to the raw data, these blocks happened to contain some quite
> sensitive information. I won't share this information
> publicitly and would avoid leaking it as much as it seems
> reasonable. If this data is of real and great help, please
> let me know, I will prepare and send a link privately.
> Sorry about that.
> 

Ok. I see. But I really need to have for analysis as minimum last
segment's raw content #23445 (ss_seq = 305303, first block #48015360).
Because I need to conclude what the reason of failure with checkpoint
attach. I can see from code analysis that only raw dump can give to me
more hints than additional debug output.

As I can see, the most part of last partial segment is contained by
metadata files. Of course, you can share raw dump privately only with
me. I need to understand the metadata state only.

> > Tomorrow, I prepare patch with additional debug output for
> > deeper investigation of the issue on your side.
> 
> Is there any chance to register a different fs aside with
> "official" nilfs2? Would such a simple change be sufficient?
> 
> diff -ur org/super.c new/super.c
> --- org/super.c	2013-03-19 02:17:23.922469000 +0400
> +++ new/super.c	2013-03-19 02:16:20.440634698 +0400
> @@ -1356,7 +1356,7 @@
>  
>  struct file_system_type nilfs_fs_type = {
>  	.owner    = THIS_MODULE,
> -	.name     = "nilfs2",
> +	.name     = "nilfs2-dbg",
>  	.mount    = nilfs_mount,
>  	.kill_sb  = kill_block_super,
>  	.fs_flags = FS_REQUIRES_DEV,
> 
> What I want is to whenever possible avoid rebooting a machine
> I am using for experimentation. It has /home on a nilfs2
> partition and there're usually open user files on it.
> 

I think that you can have more simple solution. I suggest to have
special experimental build of the kernel that you can choose in the grub
menu. Moreover, debug output will be completely disabled by means of
#undef macro. Anyway, I need to analyze raw dump before offering to you
a patch with additional debug output.

Thanks,
Vyacheslav Dubeyko.

> Thanks and regards.
> Alexander Bezrukov.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
