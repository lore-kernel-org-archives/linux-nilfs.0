From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [RFC] nilfs2: xattrs support implementation idea
Date: Sun, 29 Sep 2013 01:00:37 +0900 (JST)
Message-ID: <20130929.010037.212895338.konishi.ryusuke@lab.ntt.co.jp>
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
>> For the tree of xanodes, it seems a bit inefficent because it is
>> implemented over xafile (meta data file), and this introduces
>> threefold tree lookups to access the target disk block:
>> 
>>   xanode tree lookup --> xafile btree lookup --> DAT btree lookup
>> 
>> Simple block chaining over xafile may be better for most cases.
>> 
>> I think the tree-over-xafile implementation is a candidate, but please
>> try considering ideas to replace the the tree based lookup into an
>> index based access over xafile.
>> 
> 
> First of all, in my concept the xafile is aggregate of xanodes. Every
> xanode is accessed by index in xafile. So, namely index based access
> over xafile is used in my implementation.

I said this is "For the tree of xanodes".  You are misunderstanding.
I don't comment on shared xanodes here.

Yes, of course, I know block access over xafile i_xattr can be used
for that index access.  That is what we intended to prepare the
i_xattr field and the reserved extended attribute metadata file
(NILFS_XATTR_INO)

> The xafile as container of xanodes is important concept from the GC
> point of view. Data blocks and xattr blocks have different nature of
> aging. So, mixture of data and xattr blocks can be not GC
> friendly.

Yes, I know.  I don't deny using xafile.  The xafile approach also has
the merit of disk format compatibility.  These are exactly the reason
why original nilfs design is reserving xattr inode number.

> Access to xanodes by means of index over xafile is
> important concept too. Because namely index of xanode in xafile is
> stored as xanode number in header and other structures. So, xafile
> as metadata file hides problem of translation logical index (xanode
> number) into real block number.
> 
> About lookup... On-disk inode keeps xattrs by itself in the inline
> xanode case. So, we don't need to search an inline xanode in such case.
> An inode keeps xanode number (or index of xafile's node) in the case of
> shared xanode. It means that we have metadata file lookup overhead only
> (xafile btree lookup --> DAT btree lookup). An inode keeps xanode number
> of a first xanode of dedicated xanodes' tree. Only this inode possesses
> by such dedicated tree. So, dedicated tree will not big in ordinary
> case.

I am not worrying about lookup of inline xattr or shared xattr.  I
inteded to comment on the tree type xattr.

> The dedicated xanodes' tree can be big if an inode will have very
> big count of xattrs (or xattrs with big content size). Every xanode has
> small reserved space for index keys. But, initially, only first xanode
> is used for storing index keys. And reserved space for index keys is
> growing in the case of necessity to have more index keys. I suppose that
> one index level will be enough for most cases. So, usually, reading of
> first xanode will be enough for getting knowledge about all leaf xanodes
> in dedicated xanodes' tree.

Ok, you are pointing out that the depth of xattr trees is expected to
be small.  That is reasonable.

> Yes, (xafile btree lookup --> DAT btree lookup) can be the reason of
> overhead. But I think that we need to optimize this overhead for all
> use-cases, anyway.

Agreed.


>> For the inline xattr, I think it should not be mandatory.  It should
>> be an option for users who wants faster accesses to the extended
>> attributes and can accept reformat of the file system with 256-bit
>> size inodes for that purpose.
>> 
> 
> Yes, sure. Inline xattrs are optional. If a user hasn't opportunity (or
> desire) for reformat NILFS2 volume then it will not use inline xattrs
> completely.

Okay.

>> > /*
>> >  * struct nilfs_inline_xanode_header - header of inline node
>> >  * @magic: magic number for identification
>> >  * @type: node type
>> >  * @entries: number of entries in node
>> >  * @log_node_size: log2(node size in bytes)
>> 
>> log2(node size in bytes) - 10 ?
>> 
>> 4-bit width log_node_size only can represent 0~15 bytes.
>> 
> 
> I think that xafile's xanode size can be in range: 1KB (1024) - 32KB
> (32768). I suppose that maximum value in 32KB is enough for all cases.
> So, it needs 15 bytes for 32KB node size.

Ok, this is my misunderstanding.

4-bit width log_node_size can represent 2^0 ~ 2^15 bytes (32KB).


>> >  * @flags: node flags
>> >  */
>> > struct nilfs_inline_xanode_header {
>> >         __le16 magic;
>> 
>> Is this magic field necessary?   The reserved field
>> at the end of the current disk inode is valuable.
>> 
>> Setting the same magic number to all inodes seems wasteful.
>> 
> 
> The magic field is useful for consistency checking. And magic number
> keeps for the whole xanode. I don't think that 2-byte value wastes 4KB
> xanode, for example. Moreover, I use magic for detecting presence of
> inline xanode in extended space of on-disk inode. Of course, we can
> leave padding field at the end of on-disk inode untouched. But it needs
> to use another way of detecting inline xanode presence. What do you
> suggest?

I am not denying adding 2-bytes magic number to 4k-bytes blocks on
xafile.

What I am saying is the magic number inserted in nilfs_inode.

i_pad is guaranteed to be zero-filled by mkfs, so you don't have to
add 16-bit magic field; a few bits magic number field is enough for
the inlined xattr header.

You can do the consistency check with the few bit magic number and
whether i_xattr is zero or not. (for compatibility reason, we must
define i_xattr is zero if and only if xattr is not used.)

We agreed that inline xattr should be optional, so, I think moving
nilfs_inline_xanode_header into the extended inode area is a
reasonable option.

Anyway, I want to reserve at least a 16-bit field for inode checksum
functionality.


>> > /*
>> >  * struct nilfs_xattr_inline_key - xattr key for inline node
>> >  * @type: key type
>> >  * @flags: key's flags
>> >  * @reserved: reserved field
>> >  * @name_index: attribute name index
>> >  * @name_hash: name hash
>> >  * @entry_offset: entry offset inside the node
>> >  * @entry_size: size of entry in bytes
>> >  */
>> > struct nilfs_xattr_inline_key {
>> >         u8 type : 2;
>> >         u8 flags : 6;
>> >         u8 reserved;
>> >         __le16 name_index;
>> >         __le32 name_hash;
>> >         __le16 entry_offset;
>> >         __le16 entry_size;
>> > } __packed;
>> 
>> For what purpose is the type field used ?
> 
> The purpose of "type" field is to distinguish different type of xanode's
> headers or keys. Namely, for example, detecting that we have header of
> inline xanode, shared xanode or tree xanode.

That looks to be defined as the purpose of "flags" field.  See the
following definitions:

> /* Xattr key's flags */
> #define NILFS_INLINE_NODE_KEY           0
> #define NILFS_SHARED_XANODE_KEY         1
> #define NILFS_XANODE_INDEX_KEY          2
> #define NILFS_XANODE_LEAF_KEY           3


>> Again, the type field.  What is the difference between the type field
>> and the flags field ?
>> 
> 
> The type field is part of flags field. So, it can be extracted from
> flags field by means of mask.

OK, please reorganize the two fields when you will get rid of
bit-field uses.


>> > struct nilfs_xattr_index_key {
>> >         u8 type : 2;
>> >         u8 flags : 6;
>> >         u8 reserved1;
>> >         __le16 name_index;
>> >         __le32 name_hash;
>> >         __le64 parent;
>> >         __le64 leaf;
>> > } __packed;
>> 
>> Why is the "parent" field required ?
>> 
>> The size of this structure is 24 bytes.
>> It fits in 16 bytes structure if the parent field is eliminable.
>> Otherwise, you need 8 more pad bytes to align on-disk structures 
>> to 8 byte boundary.
> 
> I need to think over the real necessity of "parent" field. But my
> initial intention was to have backpointer on index xanode that describe
> this xanode as leaf.

I know it.  What I was asking about is the necessity of the "parent"
field.

> But now I doubt that keeps this value in an index
> key is a good idea. Maybe, it makes sense to keep this value in xanode's
> header in the case of real necessity in "parent" backpointer. So, I need
> to reflect about it.

Ok, please reconsider it as needed when you proceed implementation.


Regards,
Ryusuke Konishi

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
