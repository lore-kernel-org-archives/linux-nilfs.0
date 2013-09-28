From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [RFC] nilfs2: xattrs support implementation idea
Date: Sun, 29 Sep 2013 00:01:45 +0900 (JST)
Message-ID: <20130929.000145.46389165.konishi.ryusuke@lab.ntt.co.jp>
References: <1379587669.2310.48.camel@slavad-ubuntu>
	<20130924.000730.143627251.konishi.ryusuke@lab.ntt.co.jp>
	<1380204479.2335.128.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1380204479.2335.128.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Benixon.Dhas-Sjgp3cTcYWE@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 26 Sep 2013 18:07:59 +0400, Vyacheslav Dubeyko wrote:
> On Tue, 2013-09-24 at 00:07 +0900, Ryusuke Konishi wrote:
> 
>> The shared xanode you defined looks to be intended to share a disk
>> block from several inodes (for efficiency of disk block usage) since
>> nilfs_xattr_shared_key has a backpointer, an inode number field.
>> 
>> I think you would rather consider sharing the same (small) attribute
>> content among many inodes because the same attribute set is often
>> associated to many files or directories widely, such as tree wide or
>> file system wide.  For this type of block sharing, no inode number is
>> needed in the attribute payload.
>> 
> 
> So, maybe I miss something but I don't quite follow your thought about
> attribute content sharing between several inodes. What do you mean?

I meant allowing multiple inodes to share the same set of extended
attributes which contains same keys and values.  This is what
ext2/ext3/ext4 file systems trying to do.

> I have such understanding. The xattr is a pair of a name and a binary
> stream. So, of course, many inodes have xattrs with the same name. But
> does it mean that such xattrs have identical binary streams? I doubt
> that identity of xattrs' binary streams is very frequent event.

I measured how much xattrs are duplicating by using getfattr command
on my fedora 19 system.


 # getfattr -RPh -e hex -dm '.*' / 2>/dev/null | sed -e '/^\#/d' | awk 'BEGIN{RS="";OFS=""}{$1=$1;print}' | wc -l
 143103

The system has 143103 extended attibutes sets, where sed command is
removing comment line, awk command is joining multiple extended
attributes per file or directory, and wc command is used to count
them.

Then, the number of extended attribute sets was reduced to 441 after I
removed duplicated ones with sort and uniq commands:

 # getfattr -RPh -e hex -dm '.*' / 2>/dev/null | sed -e '/^\#/d' |awk 'BEGIN{RS="";OFS=""}{$1=$1;print}' | sort | uniq | wc -l
 441

Although POSIX ACLs are not handled in this measurement (we can use
getfacl command for similiar purpose), sharing the same extended
attribute content looks to be effective to reduce the on-disk data
size.


I also measured the total size of extended attibutes on the system:

 # getfattr -RPh -dm '.*' / 2>/dev/null | sed -e '/^\#/d' |awk 'BEGIN{RS="";OFS=""}{$1=$1;print}' | wc -c
 6857670

It was using about 6857670 bytes (including both key and values), and
this corresponds to about 1675 4k-blocks.  After I removed duplicating
attribute sets, it was reduced to 27453 bytes (about 7 4k-blocks).

 # getfattr -RPh -dm '.*' / 2>/dev/null | sed -e '/^\#/d' |awk 'BEGIN{RS="";OFS=""}{$1=$1;print}' | sort | uniq | wc -c
 27453

If we can share xanodes effectively, the amount of disk space and
access performance of xattrs will be greatly-improved.

However, it seems that supporting multiple xanode sizes which are
smaller than block size and shared among multiple inodes, is
preferable to achieve that goal.


> For example, many inodes can have system.posix_acl_access ACL but
> content of binary streams will be different (namely,
> permitted/denied permissions set).

Usually, posix ACLs are inherited from a parent directory to its
children, so I guess there are much chance of sharing the same content
of binary streams.

> Moreover, of course, it is
> possible to use such scheme as sharing identical xattrs' content
> between several inodes. But if we need in independent xattr's
> content update for some inode then we will need to use something
> likewise COW policy. I suppose that it can be complicated technique.

I don't think COW policy is difficult.  That is what ext2/ext3/ext4
are doing.  You can use mbcache for that purpose and for finding the
xanode having the same content.


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
