From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC] nilfs2: xattrs support implementation idea
Date: Wed, 02 Oct 2013 12:11:07 +0400
Message-ID: <1380701467.2355.63.camel@slavad-ubuntu>
References: <1379587669.2310.48.camel@slavad-ubuntu>
	 <20130924.000730.143627251.konishi.ryusuke@lab.ntt.co.jp>
	 <1380204479.2335.128.camel@slavad-ubuntu>
	 <20130929.000145.46389165.konishi.ryusuke@lab.ntt.co.jp>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=wC05AE+qJTeHfnFb7DwdEs7afB5R2HkyHp5q1mMq/h4=;
	b=fmPGtBaMhPuUd0Tq29aO+/hcV70ZbT77fhW3PgOWC8gjSATuXOzR3yGOAtfJHsFkv0Kk/Y6GvE/oijyP9nYrpzTPn8NtU+7iLx77zFqtZUunVNumBtdygxXpzalSFc2l;
In-Reply-To: <20130929.000145.46389165.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Benixon.Dhas-Sjgp3cTcYWE@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

On Sun, 2013-09-29 at 00:01 +0900, Ryusuke Konishi wrote:

[snip]
> I measured how much xattrs are duplicating by using getfattr command
> on my fedora 19 system.
> 
> 
>  # getfattr -RPh -e hex -dm '.*' / 2>/dev/null | sed -e '/^\#/d' | awk 'BEGIN{RS="";OFS=""}{$1=$1;print}' | wc -l
>  143103
> 
> The system has 143103 extended attibutes sets, where sed command is
> removing comment line, awk command is joining multiple extended
> attributes per file or directory, and wc command is used to count
> them.
> 
> Then, the number of extended attribute sets was reduced to 441 after I
> removed duplicated ones with sort and uniq commands:
> 
>  # getfattr -RPh -e hex -dm '.*' / 2>/dev/null | sed -e '/^\#/d' |awk 'BEGIN{RS="";OFS=""}{$1=$1;print}' | sort | uniq | wc -l
>  441
> 
> Although POSIX ACLs are not handled in this measurement (we can use
> getfacl command for similiar purpose), sharing the same extended
> attribute content looks to be effective to reduce the on-disk data
> size.
> 
> 
> I also measured the total size of extended attibutes on the system:
> 
>  # getfattr -RPh -dm '.*' / 2>/dev/null | sed -e '/^\#/d' |awk 'BEGIN{RS="";OFS=""}{$1=$1;print}' | wc -c
>  6857670
> 
> It was using about 6857670 bytes (including both key and values), and
> this corresponds to about 1675 4k-blocks.  After I removed duplicating
> attribute sets, it was reduced to 27453 bytes (about 7 4k-blocks).
> 
>  # getfattr -RPh -dm '.*' / 2>/dev/null | sed -e '/^\#/d' |awk 'BEGIN{RS="";OFS=""}{$1=$1;print}' | sort | uniq | wc -c
>  27453
> 
> If we can share xanodes effectively, the amount of disk space and
> access performance of xattrs will be greatly-improved.
> 

Ok. I see now.

So, I have achieved some vision after contemplation about what you said.
Yes, I accept your arguments but, anyway, it needs to be accurate. We
should balance between efficient decreasing the used disk space and
efficient access performance.

First of all, I suppose that sharing xattr between multiple inodes makes
sense only for the case when inode has one xattr. In such case we can as
to decrease used disk space as to access to xattr content efficiently.
Otherwise, if inode has several xattrs then efficiency of accesses to
xattrs will degrade significantly, especially for the case of listxattr
operations. I mean that we will keep shared xattrs ordered on the basis
of hashes and, as a result, trying to access to several shared xattrs of
inode will be ended with potential necessity to read (and modify)
several blocks (potentially, count of blocks may be equal to count of
xattrs). Moreover, for example, on my system I have many inodes that
have one duplicated xattr - "security.selinux".

But if a user has inline xanodes then such xattr will be replicated in
inline xanodes. So, does it make sense to share xattr anyway for the
case of inline xanode presence? What do you think? I suppose that inline
xanode will be more efficient storage but without achieving efficiency
in decreasing used space.

I think that concept of independent shared xanodes should be evolved in
concept of shared xanodes' tree. I assume that I have vision of
efficient structure of shared xanodes' tree. But I need to think through
it more deeply before sharing my vision.

Secondly, I think that it needs to take into account and xattrs' name
duplication. Because even if xattrs have different contents then it can
have identical name very frequently. So, it is possible to have one
names tree for the whole xafile. As a result, we will store fixed size
name hash in the key of xattr instead of name with variable size.
Usually, it is used small number of predetermined xattr names under
Linux and xattr's names tree can be small. Anyway, I suppose that I have
vision of efficient structure of xattr's name tree. The getxattr
operation doesn't need to access xattr's names tree because we can
compute hash for requested name. The setxattr operation is provided by
xattr name also but it will need to check necessity to increase (or
decrease) name reference count. Only listxattr operation needs in
extracting names from xattr's names tree on the basis of known hashes.
However, theoretically, it is possible to be without name's reference
counter if xattr's names tree will not support operation of name
removing from the tree.

So, I have such vision of xafile's concepts, currently:
(1) Single xattr's names tree. The names tree stores and share xattrs'
name between inodes.
(2) Inline xanodes (OPTIONAL). It keeps xattrs in extended part of
inode.
(3) Single tree of shared xanodes. It stores xattrs that are shared
between inodes. Shared xattr is accessible in RO mode only. A xattr can
be shared if an inode has one xattr only. If some inode needs in
independent modification of shared xattr then: (A) modified xattr will
be stored in inode's inline xanode or dedicated tree of xanodes; (B)
reference count of shared xattr will be decremented.
(4) Inode's dedicated tree of xanodes. It keeps inode's xattrs in the
xanodes' tree. 

> However, it seems that supporting multiple xanode sizes which are
> smaller than block size and shared among multiple inodes, is
> preferable to achieve that goal.
> 

Yes, I think that it makes sense. I'll take it into account.

By the way, I will be unavailable be e-mail during one week (maybe two
weeks) because of business trip.

With the best regards,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
