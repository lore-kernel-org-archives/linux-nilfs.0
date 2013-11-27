From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC][PATCH 00/15] nilfs2: introduce xattrs support (first step)
Date: Wed, 27 Nov 2013 16:40:58 +0400
Message-ID: <1385556058.2589.65.camel@slavad-ubuntu>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=nholaCS09WvYpoy+n9OpaEqLbdjseZCXJ2u+Fdw/+5M=;
	b=Qa2hsqZWdK6+nPPh9wccg9kGCDr/myUCa5IXmujelnU22mTsDOjYZ+Wvcom/MZjjMumrkhlbUQ6KOk+Qnl2WQLYSKeAPYT3gnDIdNNI8Os5wiI5oJt0IMd4qHRCFBQVT;
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

This patchset is a first step implementation of xattrs support
in NILFS2 file system driver. Currently, suggested patchset
is not for inclusion into kernel but only for review and
discussion.

The implementation of xattrs support in NILFS2 will be
divided on several steps:
(1) inode has only one xanode [DONE];
(2) inode's dedicated xanodes tree support [TODO];
(3) inline xanodes support [TODO];
(4) shared xanodes support [TODO];
(5) shared xaname and xaval trees support [TODO].

----------------------------------------------------------------
                     HOW DOES NILFS2 KEEP XATTRs?
----------------------------------------------------------------

Extended file attributes (xattrs) is a file system feature that
enables users to associate computer files with metadata not
interpreted by the filesystem. Any regular file or directory may
have extended attributes consisting of a name and associated data.
The name must be a null-terminated string prefixed by a namespace
identifier and a dot character. Currently, four namespaces exist:
user, trusted, security and system. The user namespace has no
restrictions with regard to naming or contents. The system namespace
is primarily used by the kernel for access control lists.
The security namespace is used by SELinux

There are two possible places of storing xattrs:
(1) inline xattr node (xanode) [OPTIONAL];
(2) xattr file (xafile).

The inline xanode is simply extention of inode space. First 128
bytes is used by on-disk inode structure. The rest space is used
for inline xanode. Inline xanodes are optional feature.

The xafile is metadata file. It contains group descriptors block,
bitmap blocks and xanodes areas. The xafile is simply aggregate of
xanodes that can provide a xanode of some size (1KB, 2 KB or 4 KB)
by identification number (ID) or, in other words, by index.

Xanodes area of xafile can includes:
(1) shared xaname tree [OPTIONAL];
(2) shared xaval tree [OPTIONAL];
(3) shared xanodes;
(4) dedicated trees of xanodes.

The shared xaname tree contains unique strings of xattr's names.
Goal of such tree is to keep xattr's names in deduplicated manner.
The shared xaval tree has goal to overcome duplication of identical
xattr's value between different inodes. The shared xanode concept
has goal to share space of one block between several inodes for the
case when inode has small number of xattrs with small size or inode
keeps name and\or value in shared xatrees. Dedicated tree of xanodes
needs in the case when one inode has many xattrs with significant
size.

----------------------------------------------------------------
               INLINE XANODE (OPTIONAL)
----------------------------------------------------------------

The inline xanode is extention of inode space. The raw (on-disk)
inode has 0x80 (128) bytes in size. Thereby, xanodes live in
extended space of inode. For example, if on-disk inode has 256
bytes then xanode is 128 bytes.

Inline xanode structure:

------------------------------------------------------------------
|       ****        | HEADER | INLINE KEYS | FREE AREA | ENTRIES |
------------------------------------------------------------------
|<--- 128 bytes --->|<-------------- inline xanode ------------->|
|<------------------------  inode  ----------------------------->|

The xanode begins with header that describes important details
about the node at whole. The main area of xanode keeps keys and
entries. Keys begin near after header and its grow towards
entries. The chain of keys is ended by termination marker
("end key") that is simply four bytes zeroed field. Entries
begin from xanode end and its grow from the end towards
"end key".

NILFS2 volume contains inline xanodes if s_feature_incompat
field of superblock contains NILFS_FEATURE_INCOMPAT_INLINE_XANODE
flag, s_inode_size of superblock keeps value is greater than
128 bytes (256, 512 and so on) and s_inline_xanode_size keeps size
of inode's extended area. It is possible to define presence
of initialized inline xanode in extended area of inode by means of
checking magic in header of inline xanode.

----------------------------------------------------------------
                     XAFILE STRUCTURE
----------------------------------------------------------------

The xafile is metadata file that, basically, has such structure:

+0                 +1       +2
+------------------+--------+------------------------------+
+ Group descriptor | Bitmap |       Xanodes area           |
+ block            | block  |                              |
+------------------+--------+------------------------------+

Thereby, xafile is simply aggregate of xanodes that can provide
xanode of some size (1KB, 2 KB or 4 KB) by identification
number (ID).

NILFS2 volume contains xafile if s_feature_compat_ro field of
superblock contains NILFS_FEATURE_COMPAT_RO_XAFILE flag.
The s_xafile_xanode_size field of superblock keeps value of
xanode's size in bytes which is determined during mkfs phase.

The xafile's xanodes area contains:
(1) single tree of xattr names are shared between inodes (xaname tree);
(2) single tree of xattr values are shared between inodes (xaval tree);
(3) aggregation of shared xanodes;
(4) aggregation of dedicated xanode trees (xanode tree).

The xanodes area haven't any predetermined order of xanodes.
Simply speaking, this area is aggregation of xanodes of different trees.
Every tree begins from a xanode that keeps knowledge about other xanodes
in a tree. Superblock of NILFS2 volume keeps IDs for head xanodes of
xaname tree and xaval tree. The i_xattr field of on-disk inode can keep
ID of shared xanode or head xanode of dedicated tree.

----------------------------------------------------------------
                        XANAME TREE
----------------------------------------------------------------

The xaname tree contains unique strings of xattr's names.
Goal of such tree is to keep xattr's names in deduplicated manner.
Namely, usually, xattr keeps as name as value. As a result, many
xattrs on a volume have identical name that is replicated between
these xattrs. Keeping unique name string in xaname tree gives
opportunity to decrease used space by means of sharing name string
between xattrs.

----------------------------------------------------------------
                           XAVAL TREE
----------------------------------------------------------------

The xaval tree has goal to overcome duplication of identical xattr's
value between different inodes. Keeping unique xattr's value in
xaval tree gives opportunity to decrease used space by means of sharing
identical xattr's value between different inodes in RO mode. If some
inode needs in modification of shared xattr's value then it keeps
xattr in shared xanode or dedicated tree after modification.

----------------------------------------------------------------
                         SHARED XATREE
----------------------------------------------------------------

Shared xanodes tree (xaname tree, xaval tree)

The shared xanodes tree begins from header xanode that keeps
fixed size table of xanode's numbers. These xanode's numbers
describe all xanodes of the tree.

------------  ------------  ------------  ------------
|  header  |  |  leaf    |  |   ***    |  |  leaf    |
|  xanode  |  |  xanode  |  |   ***    |  |  xanode  |
------------  ------------  ------------  ------------
              |<------------  xanode's tree  ------->|

The header xanode begins from header that defines base
parameters of the tree at whole. The rest place of the
header xanode contains fixed size table of xanode's
numbers.

Every leaf of shared xanodes tree can keep entries
with length in some predetermined range (granularity).
Thereby, an entry in xanode has fixed size.
As a result, table in header xanode describes all
tree's xanodes which keep entries that differ by
granularity value and it have values inside
granularity range.

----------------------------------------------------------------
                     SHARED XANODE
----------------------------------------------------------------

If an inode has small number of xattrs with small size then
it will be used a shared xanode. The shared xanode has such
structure:

-------------------------
|         HEADER        |
-------------------------
|  LEAF KEYS (inode 1)  |
-------------------------
|  LEAF KEYS (*******)  |
-------------------------
|  LEAF KEYS (inode N)  |
-------------------------
|                       |
|       FREE AREA       |
|                       |
-------------------------
|    ENTRIES (inode N)  |
-------------------------
|    ENTRIES (*******)  |
-------------------------
|    ENTRIES (inode 1)  |
-------------------------

----------------------------------------------------------------
                     DEDICATED XANODES TREE
----------------------------------------------------------------

If an inode has many xattrs or xattrs of significant
size then it will be used xanodes' tree is dedicated to the inode.
The tree xanode has such structure:

----------------
|    HEADER    |
----------------
|  INDEX KEYS  |
----------------
|  LEAF KEYS   |
----------------
|              |
|  FREE AREA   |
|              |
----------------
|    ENTRIES   |
----------------

The tree xanode begins with header. Initially, empty xanode
contains reserved place for 8 index keys. First position keeps
index key that describes xanode itself. It is located leaf keys
after space that is reserved for index keys. Leaf keys grow
towards entries. The chain of keys is ended by termination marker
("end key"). Entries begin from xanode end and its grow from the
end towards "end key".

Thereby, xanode can be a mixture of index keys with [leaf key;
entry] pairs or it can contain only index keys. A xanode can
contain [4 | 8 | 16 | 32 |...| and so on] index keys. Firstly, when
inode has only one xanode in a tree then it hasn't any necessity
in index keys. First xanode in tree will keep index keys for
4 xanode are added after first one. Then number of index keys in
first xanode will be increased while first xanode is became
index xanode completely. Thereby, an inode keeps ID number of
first xanode in the tree and reading first xanode gives knowledge
about the next leaf node on the basis of index keys or searching
xattr (if first xanode keeps entries yet). Finally, after
exhausting of first inode by index keys, index keys are stored
in xanode are described in first xanode, and so on.

----------------------------------------------------------------
                 XANODE ENTRY STRUCTURE
----------------------------------------------------------------

The entry of xanode has purpose to store name and
binary value pair. But really the xattr's name
or/and xattr's value can be shared. As a result,
an entry can store different combination of data.

Structure of xanode's entry in common case:

----------------------------------------
| name[variable_length] | binary value |
----------------------------------------
|<----------   entry_size  ----------->|

The name hash defines length of the name. The length
of binary value is defined as difference between
entry_size and name_len.

Structure of xanode's entry in the case of name sharing:

----------------------------------------
|             binary value             |
----------------------------------------
|<----------   entry_size  ----------->|

Structure of xanode's entry in the case of value sharing:

----------------------------------------
| name[variable_length] |  value hash  |
----------------------------------------
|<----------   entry_size  ----------->|

Structure of xanode's entry in the case of name and
value sharing:

----------------------------------------
|             value hash               |
----------------------------------------
|<----------   entry_size  ----------->|

With the best regards,
Vyacheslav Dubeyko.
---

 fs/nilfs2/Kconfig          |   38 +
 fs/nilfs2/Makefile         |    6 +-
 fs/nilfs2/acl.c            |  319 +++++++
 fs/nilfs2/acl.h            |   58 ++
 fs/nilfs2/bmap.c           |    1 +
 fs/nilfs2/file.c           |    7 +
 fs/nilfs2/inode.c          |   22 +-
 fs/nilfs2/namei.c          |   42 +
 fs/nilfs2/nilfs.h          |   28 +-
 fs/nilfs2/segment.c        |   22 +
 fs/nilfs2/super.c          |   20 +-
 fs/nilfs2/the_nilfs.c      |   19 +
 fs/nilfs2/the_nilfs.h      |    4 +
 fs/nilfs2/xafile.c         | 2067 ++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/xafile.h         |  453 ++++++++++
 fs/nilfs2/xattr.c          |   90 ++
 fs/nilfs2/xattr.h          |   78 ++
 fs/nilfs2/xattr_security.c |  190 ++++
 fs/nilfs2/xattr_trusted.c  |  126 +++
 fs/nilfs2/xattr_user.c     |  123 +++
 include/linux/nilfs2_fs.h  |   17 +-
 21 files changed, 3683 insertions(+), 47 deletions(-)
-- 
1.7.9.5


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
