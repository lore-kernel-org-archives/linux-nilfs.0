From: Taesoo Kim <taesoo-3s7WtUTddSA@public.gmane.org>
Subject: Re: searching checkpoints contaning an inode (or a filename)
Date: Sat, 6 Jul 2013 07:24:13 -0400
Message-ID: <20130706112413.GG23851@taesoo.org>
References: <20130705201701.GE23851@taesoo.org>
 <B16ADF79-9EF9-46E8-95F8-9D4815E86C64@dubeyko.com>
 <20130706.185038.523614087.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=bmkaYRGedYwyLCf2m6YxeTd8l3SM2Y2mKLbjNZVpbDc=;
        b=sREaBB0oR+0kEEOO2kvKF7SDUkNKEzCwgJlBzfm91MAXQ2U8S/Lv59Q+KjoU9Ka+GT
         Ee/plkV2dL1nCOl4sAtZxz1GAAzo05BpXM5t79pq920/izqiMJcwYcDuz59Do6OqJb2d
         MIql8pikKqAFTqx+R5IRiIzJvgGvOWuL8AzfCxxjsUpFHpIZTGX6wGXX5Q/HC5mxKBZg
         3KhFBDBWSLGDIbt0BT/KHVMvDZSNYRKJjfNK/ZxpcFEbhhSZ/UFb3mx8J/tG2w+34FdY
         cX9uayvCHqqxsZgt2lLFmod4gucUjD5z3QhqQnKdb6ZT2gqNn0LFWjMrm+TEyRaqZg1U
         mkTA==
Content-Disposition: inline
In-Reply-To: <20130706.185038.523614087.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke and Vyacheslav,

> >> q1. how can I enumerate a list of cps, given a filename?
> >> (I know I can mount each cp to check whether there is my file or
> >> not, as time-machine (in mac) does)
> >> 
> 
> I think it's hard to implement this feature efficiently because nilfs
> doesn't have an efficient lookup method of past inodes from a file
> name.
> 
> > You can use dumpseg fot this goal. To be honest this way not so
> > simple. You can get inode id from ls output ("ls -i"), for example.
> > And then you need to get dumpseg for all segments and select
> > output for searching inode. Of course, it needs to implement
> > special feature for easy retrieving such data. 
> 
> dumpseg is a debug tool and it doesn't provide a solid way since it
> directly scans on-disk blocks from userland.
> 
> We should adds an ioctl for that if there is a reasonable purpose, but
> I don't know it can be implemented nicely.
> 

I don't know how difficult to embed a backward link (to previous cp)
in each inode? So given a current inode, I can walk inode-btree of cp
again to find the previous one, possibly with ioctl().

But, searching inodes of a deleted path seems still difficult and 
hard to implement nicely, without walking all cps to figure out.

> >> q2. compute diff or cat against previous files in a specific cp?
> >> (instead of mounting and copying them individually to my /tmp)
> >> 
> > 
> > As I understand, currently, we haven't this as feature of any
> > NILFS2's tool or internal file system technique.
> 
> An experimental patchset and a tool exist:
> 
> http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg00827.html
> 
> nilfs-diff:
> 
>    git://github.com/konis/nilfs-utils.git (diff branch)
> 
> diff API:
> 
>    git://github.com/konis/nilfs2.git (diffapi branch)
> 
> 
> But I have never sent this to the mainline because the patchset has
> important limitations for practical use in addition to needing a disk
> format change.
> 

I will definitely check the patch set, and thank you for the design
doc as well.

Thank you!
Taesoo

> 
> Regards,
> Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
