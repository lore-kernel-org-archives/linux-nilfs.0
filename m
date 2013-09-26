From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC] nilfs2: xattrs support implementation idea
Date: Thu, 26 Sep 2013 18:07:59 +0400
Message-ID: <1380204479.2335.128.camel@slavad-ubuntu>
References: <1379489814.2365.54.camel@slavad-ubuntu>
	 <20130919.010734.64997601.konishi.ryusuke@lab.ntt.co.jp>
	 <1379587669.2310.48.camel@slavad-ubuntu>
	 <20130924.000730.143627251.konishi.ryusuke@lab.ntt.co.jp>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=sK6WzyWcLTMsxD7NUfDIS+vsnsifRGN6/opcWwHb7+8=;
	b=HlwCavLo8Xw4r9QcI69zmVNF2ojMQFGTPSeJsvj8JgKDSdeCFBDx4LS8/TBrwX40RZ2y9pFDTnvGb8TsSwyVQ2KKWEmqO1KMWIYyUnX+AcHMQ4VhPGnagN36dLCLdAZl;
In-Reply-To: <20130924.000730.143627251.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Benixon.Dhas-Sjgp3cTcYWE@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Ryusuke,

On Fri, 2013-09-20 at 03:15 +0900, Ryusuke Konishi wrote:

> 
>Before that, I have a request on the use of bit-fields in on-disk
>structure definitions.
>

Ok. It's reasonable request. I'll take it into account.


On Tue, 2013-09-24 at 00:07 +0900, Ryusuke Konishi wrote:

> The shared xanode you defined looks to be intended to share a disk
> block from several inodes (for efficiency of disk block usage) since
> nilfs_xattr_shared_key has a backpointer, an inode number field.
> 
> I think you would rather consider sharing the same (small) attribute
> content among many inodes because the same attribute set is often
> associated to many files or directories widely, such as tree wide or
> file system wide.  For this type of block sharing, no inode number is
> needed in the attribute payload.
> 

So, maybe I miss something but I don't quite follow your thought about
attribute content sharing between several inodes. What do you mean?

I have such understanding. The xattr is a pair of a name and a binary
stream. So, of course, many inodes have xattrs with the same name. But
does it mean that such xattrs have identical binary streams? I doubt
that identity of xattrs' binary streams is very frequent event. For
example, many inodes can have system.posix_acl_access ACL but content of
binary streams will be different (namely, permitted/denied permissions
set). Moreover, of course, it is possible to use such scheme as sharing
identical xattrs' content between several inodes. But if we need in
independent xattr's content update for some inode then we will need to
use something likewise COW policy. I suppose that it can be complicated
technique.

Yes, I dislike also the necessity to have inode number in the key that
it is used in shared xanode. But inode number is essential for the
shared xanode case. Otherwise, sorting of xattr's keys will be made only
on the basis of hash of the name. As a result, we can't distinguish
xattrs of different inodes because xattrs' keys will be in unsorted
order from the point of inodes number. So, we can't make correctly such
operations as listxattr and removexattr for the shared xanode case.

But I think that shared xanode can be useful technique for the case of
unavailability of inline xanode for old NILFS2 volumes. I suppose, this
technique can be efficient for the case of small xattrs as from
performance as from GC point of view. I think about shared xanode
concept as a temporary storage for inode's xattrs while the count and
size of xattrs are small. It can be inefficient to store inode's xattrs
in shared xanode from some moment of time. If whole size (or count) of
xattrs achieve some threshold then it migrates from shared xanode into
inode's dedicated xanode's tree. Of course, also it needs to take into
consideration the synchronization overhead for the shared xanode case.

> For the tree of xanodes, it seems a bit inefficent because it is
> implemented over xafile (meta data file), and this introduces
> threefold tree lookups to access the target disk block:
> 
>   xanode tree lookup --> xafile btree lookup --> DAT btree lookup
> 
> Simple block chaining over xafile may be better for most cases.
> 
> I think the tree-over-xafile implementation is a candidate, but please
> try considering ideas to replace the the tree based lookup into an
> index based access over xafile.
> 

First of all, in my concept the xafile is aggregate of xanodes. Every
xanode is accessed by index in xafile. So, namely index based access
over xafile is used in my implementation. The xafile as container of
xanodes is important concept from the GC point of view. Data blocks and
xattr blocks have different nature of aging. So, mixture of data and
xattr blocks can be not GC friendly. Access to xanodes by means of index
over xafile is important concept too. Because namely index of xanode in
xafile is stored as xanode number in header and other structures. So,
xafile as metadata file hides problem of translation logical index
(xanode number) into real block number.

About lookup... On-disk inode keeps xattrs by itself in the inline
xanode case. So, we don't need to search an inline xanode in such case.
An inode keeps xanode number (or index of xafile's node) in the case of
shared xanode. It means that we have metadata file lookup overhead only
(xafile btree lookup --> DAT btree lookup). An inode keeps xanode number
of a first xanode of dedicated xanodes' tree. Only this inode possesses
by such dedicated tree. So, dedicated tree will not big in ordinary
case. The dedicated xanodes' tree can be big if an inode will have very
big count of xattrs (or xattrs with big content size). Every xanode has
small reserved space for index keys. But, initially, only first xanode
is used for storing index keys. And reserved space for index keys is
growing in the case of necessity to have more index keys. I suppose that
one index level will be enough for most cases. So, usually, reading of
first xanode will be enough for getting knowledge about all leaf xanodes
in dedicated xanodes' tree.

Yes, (xafile btree lookup --> DAT btree lookup) can be the reason of
overhead. But I think that we need to optimize this overhead for all
use-cases, anyway. Theoretically, it is possible to implement additional
technique. But I think that it makes sense to use existing NILFS2
internal techniques.

> For the inline xattr, I think it should not be mandatory.  It should
> be an option for users who wants faster accesses to the extended
> attributes and can accept reformat of the file system with 256-bit
> size inodes for that purpose.
> 

Yes, sure. Inline xattrs are optional. If a user hasn't opportunity (or
desire) for reformat NILFS2 volume then it will not use inline xattrs
completely.

> > /*
> >  * struct nilfs_inline_xanode_header - header of inline node
> >  * @magic: magic number for identification
> >  * @type: node type
> >  * @entries: number of entries in node
> >  * @log_node_size: log2(node size in bytes)
> 
> log2(node size in bytes) - 10 ?
> 
> 4-bit width log_node_size only can represent 0~15 bytes.
> 

I think that xafile's xanode size can be in range: 1KB (1024) - 32KB
(32768). I suppose that maximum value in 32KB is enough for all cases.
So, it needs 15 bytes for 32KB node size.

> >  * @flags: node flags
> >  */
> > struct nilfs_inline_xanode_header {
> >         __le16 magic;
> 
> Is this magic field necessary?   The reserved field
> at the end of the current disk inode is valuable.
> 
> Setting the same magic number to all inodes seems wasteful.
> 

The magic field is useful for consistency checking. And magic number
keeps for the whole xanode. I don't think that 2-byte value wastes 4KB
xanode, for example. Moreover, I use magic for detecting presence of
inline xanode in extended space of on-disk inode. Of course, we can
leave padding field at the end of on-disk inode untouched. But it needs
to use another way of detecting inline xanode presence. What do you
suggest?

> >         u8 type : 2;
> >         u8 entries : 6;
> >         u8 log_node_size : 4;
> >         u8 flags : 4;
> > } __packed;
> 
> 
> > struct nilfs_tree_xanode_header {
> >         __le16 magic;
> >         u8 type : 2;
> >         u8 entries_low : 6;
> >         u8 log_node_size : 4;
> >         u8 log_index_keys : 4;
> >         u8 flags;
> >         u8 entries_high;
> >         u8 height : 4;
> >         u8 index_keys_low : 4;
> >         u8 index_keys_high;
> >         __le32 checksum;
> >         __le64 prev;
> >         __le64 next;
> >         __le32 reserved;
> > } __packed;
> 
> This "prev" and "next" member variables are not aligned to 8-byte
> boundary ("prev" has +12 bytes offset and "next" has +20 bytes
> offset).
> 
> It is preferable to think memory alignment in __packed structures to
> avoid memory alignment error or performance penalty some architectures
> may suffer.
> 

Ok. I agree. I'll take it into account.

> 
> > /*
> >  * struct nilfs_xattr_inline_key - xattr key for inline node
> >  * @type: key type
> >  * @flags: key's flags
> >  * @reserved: reserved field
> >  * @name_index: attribute name index
> >  * @name_hash: name hash
> >  * @entry_offset: entry offset inside the node
> >  * @entry_size: size of entry in bytes
> >  */
> > struct nilfs_xattr_inline_key {
> >         u8 type : 2;
> >         u8 flags : 6;
> >         u8 reserved;
> >         __le16 name_index;
> >         __le32 name_hash;
> >         __le16 entry_offset;
> >         __le16 entry_size;
> > } __packed;
> 
> For what purpose is the type field used ?

The purpose of "type" field is to distinguish different type of xanode's
headers or keys. Namely, for example, detecting that we have header of
inline xanode, shared xanode or tree xanode.

> 
> > struct nilfs_xattr_shared_key {
> >         u8 type : 2;
> >         u8 flags : 6;
> >         u8 reserved1;
> >         __le16 name_index;
> >         __le32 name_hash;
> >         __le16 entry_offset;
> >         __le16 entry_size;
> >         __le64 ino;
> > } __packed;
> 
> The "ino" field has +12 bytes offset and is not aligned to 8 byte
> boundary.
> 

Ok. Agree.

> Again, the type field.  What is the difference between the type field
> and the flags field ?
> 

The type field is part of flags field. So, it can be extracted from
flags field by means of mask.

> > struct nilfs_xattr_index_key {
> >         u8 type : 2;
> >         u8 flags : 6;
> >         u8 reserved1;
> >         __le16 name_index;
> >         __le32 name_hash;
> >         __le64 parent;
> >         __le64 leaf;
> > } __packed;
> 
> Why is the "parent" field required ?
> 
> The size of this structure is 24 bytes.
> It fits in 16 bytes structure if the parent field is eliminable.
> Otherwise, you need 8 more pad bytes to align on-disk structures 
> to 8 byte boundary.

I need to think over the real necessity of "parent" field. But my
initial intention was to have backpointer on index xanode that describe
this xanode as leaf. But now I doubt that keeps this value in an index
key is a good idea. Maybe, it makes sense to keep this value in xanode's
header in the case of real necessity in "parent" backpointer. So, I need
to reflect about it.

> 
> > struct nilfs_xattr_leaf_key {
> >         u8 type : 2;
> >         u8 flags : 6;
> >         u8 reserved1;
> >         __le16 name_index;
> >         __le32 name_hash;
> >         __le16 entry_offset;
> >         __le16 entry_size;
> > } __packed;
> 
> This structure also needs pad bytes.
> 

Ok.

> > struct nilfs_xattr_entry {
> >         __le16 name_len;
> >         char name[0];
> > } __packed;
> 
> Note that name_len must be aligned properly in the group of the
> nilfs_xattr_entry structure even though the name field has a variable
> size.
> 
> You will need alignment calculation as NILFS_DIR_REC_LEN() macro
> provides for directory entries.
> 

Ok. I'll take it into account.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
