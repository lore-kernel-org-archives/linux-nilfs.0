From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: searching checkpoints contaning an inode (or a filename)
Date: Sat, 6 Jul 2013 11:34:32 +0400
Message-ID: <B16ADF79-9EF9-46E8-95F8-9D4815E86C64@dubeyko.com>
References: <20130705201701.GE23851@taesoo.org>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=xsCfNYFE1SUHLeDus1AaBYoRIKYyDP5zYo15C2UXJ48=;
	b=BvCExvCdBtikDFItFo1IDxuiceudAB0UHYL4nvH1bNjcgZKH/52G4tIjgKNtwGiTrFRM94kA0F39cIQ3sfWFsP1V5jExT5nXybQ5dPi1qCKD4OXLBV4nZsy7rY2F3ROp;
In-Reply-To: <20130705201701.GE23851-Q1ymHw66ZoYdnm+yROfE0A@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Taesoo Kim <taesoo-3s7WtUTddSA@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, slava-2lV3ebY47BVBDgjK7y7TUQ@public.gmane.org

Hi Taesoo,

On Jul 6, 2013, at 12:17 AM, Taesoo Kim wrote:

> Hi nilfs,
> 
> I am evaluating nilfs for using it in my machine. There are a few
> questions regarding usages:
> 
> q1. how can I enumerate a list of cps, given a filename?
> (I know I can mount each cp to check whether there is my file or
> not, as time-machine (in mac) does)
> 

You can use dumpseg fot this goal. To be honest this way not so
simple. You can get inode id from ls output ("ls -i"), for example.
And then you need to get dumpseg for all segments and select
output for searching inode. Of course, it needs to implement
special feature for easy retrieving such data. 

> q2. compute diff or cat against previous files in a specific cp?
> (instead of mounting and copying them individually to my /tmp)
> 

As I understand, currently, we haven't this as feature of any
NILFS2's tool or internal file system technique.

> q3. using nilfs as rootfs?
> (I couldn't find any people using nilfs for rootfs. Are there any
> issue on that? or just matter of performance? on updates for
> example)
> 

Many people are using NILFS2 as rootfs file system. Currently,
we have several reports about serious bugs in NILFS2 from
such people. I am investigating these issues.

> Nilfs looks conceptually nice and clean, so I can trust the
> implementation or jump directly into modifying code. Do you have any
> design notes (other than one in /Documentation and overview-nilfs1.pdf).
> 

I can share my version of design document. But I don't end it and this
document contains some mistakes in description.

http://dubeyko.com/development/FileSystems/NILFS/nilfs2-design.pdf.

So, as I understand, you are going to make some implementation in
NILFS2. Could you share what feature you want to implement?
Maybe, it make sense to implement above-mentioned by you features.
Anyway, it makes sense to distribute tasks.

PS: I am on vacation now. So, sometimes I haven't access to my e-mail.

Thanks,
Vyacheslav Dubeyko.

> Thank you in advance.
> Taesoo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
