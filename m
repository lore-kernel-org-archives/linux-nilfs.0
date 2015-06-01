From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 7/9] nilfs2: ensure that all dirty blocks are
 written out
Date: Mon, 01 Jun 2015 13:13:20 +0900 (JST)
Message-ID: <20150601.131320.1075202804382267027.konishi.ryusuke@lab.ntt.co.jp>
References: <1430647522-14304-8-git-send-email-andreas.rohner@gmx.net>
	<20150509.211741.1463241033923032068.konishi.ryusuke@lab.ntt.co.jp>
	<554F3B32.5050004@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=evuLBSW33qO9sZ9f5c955rRDMhicNENkAIj1YMQymaM=;
        b=wQqi70EkrGOJ3CN7Jv1bX2rDx5J5bU51gcdHQx56Pw5n7emO126b80c9lZ+VXBblIM
         gfs14V4ng5vQdSBGW1zSP2k6qekcPL1a5dZiYkyGZrejnVTnt0+S64e+31OjYpPOCCak
         lbcOFjev8LXmNB1TmUMzBv43AfG6i2InoDtbh8EnEhDZV11Ic0T9GownfKW+mVqv4W+X
         0LK34IxhhCp2ihN5LXQxSVf79l3hzbR1HNwvAQtqU498iobk0crzaLloVc1UKrhFCniv
         a0izG7CCXKGDTwI89u86T10QSrtbj8qz3uhGJUIJAwCYx4QNATGAiGM4PZna/RKjLoku
         2fjw==
In-Reply-To: <554F3B32.5050004-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 10 May 2015 13:04:18 +0200, Andreas Rohner wrote:
> On 2015-05-09 14:17, Ryusuke Konishi wrote:
>> On Sun,  3 May 2015 12:05:20 +0200, Andreas Rohner wrote:
[...]
>> 
>> Uum. This still looks to have potential for leak of dirty block
>> collection between DAT and SUFILE since this retry is limited by
>> the fixed retry count.
>> 
>> How about adding function temporarily turning off the live block
>> tracking and using it after this propagation loop until log write
>> finishes ?
>> 
>> It would reduce the accuracy of live block count, but is it enough ?
>> How do you think ?  We have to eliminate the possibility of the leak
>> because it can cause file system corruption.  Every checkpoint must be
>> self-contained.
> 
> How exactly could it lead to file system corruption? Maybe I miss
> something important here, but it seems to me, that no corruption is
> possible.
> 
> The nilfs_sufile_flush_cache_node() function only reads in already
> existing blocks. No new blocks are created. If I mark those blocks
> dirty, the btree is not changed at all. If I do not call
> nilfs_bmap_propagate(), then the btree stays unchanged and there are no
> dangling pointers. The resulting checkpoint should be self-contained.

Good point.  As for btree, it looks like no inconsistency issue arises
since nilfs_sufile_flush_cache_node() never inserts new blocks as you
pointed out.  Even though we also must care inconsistency between
sufile header and sufile data blocks, and block count in inode as
well, fortunately these look to be ok, too.

However, I still think it's not good to carry over dirty blocks to the
next segment construction to avoid extra checkpoint creation and to
simplify things.

From this viewpoint, I also prefer that nilfs_sufile_flush_cache() and
nilfs_sufile_flush_cache_node() are changed a bit so that they will
skip adjusting su_nlive_blks and su_nlive_lastmod if the sufile block
that includes the segment usage is not marked dirty and only_mark == 0
as well as turing off live block counting temporarily after the
sufile/DAT propagation loop.

> 
> The only problem would be, that I could lose some nlive_blks updates.
> 

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
