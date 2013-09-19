From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [RFC] nilfs2: xattrs support implementation idea
Date: Fri, 20 Sep 2013 03:15:03 +0900 (JST)
Message-ID: <20130920.031503.85401363.konishi.ryusuke@lab.ntt.co.jp>
References: <1379489814.2365.54.camel@slavad-ubuntu>
	<20130919.010734.64997601.konishi.ryusuke@lab.ntt.co.jp>
	<1379587669.2310.48.camel@slavad-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1379587669.2310.48.camel@slavad-ubuntu>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Benixon.Dhas-Sjgp3cTcYWE@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav,
On Thu, 19 Sep 2013 14:47:49 +0400, Vyacheslav Dubeyko wrote:
> Hi Ryusuke,
> 
> On Thu, 2013-09-19 at 01:07 +0900, Ryusuke Konishi wrote:
> 
>> Could you share your implementation idea again before finishing your
>> patchset?
>> 
> 
> Yes, sure. It makes sense. Please, see description below.
> 
>> Is the basic idea same as the following RFC?
>> 
>> [1] http://www.mail-archive.com/linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01298.html
>> 
> 
> I reworked this suggestion significantly. So, I describe my current
> approach and then we will elaborate a compromise solution. :)
> 
> So, I have such vision, currently.

Thank you for detail explanation.

I read through the design, but tonight I don't have enough time to
comment on it, so I will review it another day.

Before that, I have a request on the use of bit-fields in on-disk
structure definitions.

Please avoid using bit-fields in disk format definitions.  The
allocation of bit-fields depends on both compilers and architectures,
and this may sacrifice disk format compatibility.

Usually we define bit masks and bit shift values in order to write bit
operations for small size integer values.

For example,

struct nilfs_xxx {
        __le16 flags;
        ....
} __packed;

Two bit fields over the above "flags" field are define as below:

#define NILFS_XXX_FLAGS_NAME1_SHIFT    0
#define NILFS_XXX_FLAGS_NAME1_MASK     0x0003  /* a 2-bit-width field */
#define NILFS_XXX_FLAGS_NAME2_SHIFT    2
#define NILFS_XXX_FLAGS_NAME2_MASK     0x001c  /* a 3-bit-width field */
...


Regards,
Ryusuke Konishi


> There two places of storing xattrs:
> (1) inline xattr nodes (xanodes);
> (2) xattr file (xafile).
> 
> The inline xanode is extention of inode space. The raw (on-disk)
> inode has 0x80 (128) bytes in size. Thereby, xanode lives in
> extended space of inode. For example, if on-disk inode has 256
> bytes then xanode is 128 bytes. The last four bytes of inode
> (struct nilfs_inode) stores header of inline xanode.
> 
> Inline node structure:
> 
>  --------------------------------------------------------------
>  |     ****      | HEADER | INLINE KEYS | FREE AREA | ENTRIES |
>  --------------------------------------------------------------
>  |<------ 128 bytes ----->|                                   |
>  |<---------------------  inode  ---------------------------->|
> 
> The xanode begins with header that describes important details
> about the node at whole. The main area of xanode keeps keys and
> entries. Keys begin near after header and its grow towards
> entries. The chain of keys is ended by termination marker
> ("end key") that is simply four bytes zeroed field. Entries
> begin from xanode end and its grow from the end towards
> "end key".
> 
> The xafile is metadata file that, basically, has such structure:
> 
>  +0                 +1       +2
> +------------------+--------+------------------------------+
> + Group descriptor | Bitmap |       Chain of xanodes       |
> + block            | block  |                              |
> +------------------+--------+------------------------------+
> 
> Thereby, xafile is simply storage of xanodes that can provide
> xanode of some size (1KB, 2 KB or 4 KB) by identification
> number (ID).
> 
> The xanode of xafile can be two types:
> (1) xanode is shared between several inodes (shared xanode);
> (2) tree of xanodes is dedicated to one inode (tree xanode).
> Every on-disk inode stores ID of xanode (i_xattr). This ID number
> is used for getting access to xanode.
> 
> If an inode has small number of xattrs with small size then
> it will be used a shared xanode. The shared xanode has such
> structure:
> 
> -------------------------
> |         HEADER        |
> -------------------------
> |  LEAF KEYS (inode 1)  |
> -------------------------
> |  LEAF KEYS (*******)  |
> -------------------------
> |  LEAF KEYS (inode N)  |
> -------------------------
> |                       |
> |       FREE AREA       |
> |                       |
> -------------------------
> |    ENTRIES (inode N)  |
> -------------------------
> |    ENTRIES (*******)  |
> -------------------------
> |    ENTRIES (inode 1)  |
> -------------------------
> 
> Otherwise, if an inode has many xattrs or xattrs of significant
> size then it will be used xanodes' tree is dedicated to the inode.
> The tree xanode has such structure:
> 
> ----------------
> |    HEADER    |
> ----------------
> |  INDEX KEYS  |
> ----------------
> |  LEAF KEYS   |
> ----------------
> |              |
> |  FREE AREA   |
> |              |
> ----------------
> |    ENTRIES   |
> ----------------
> 
> The tree xanode begins with header. Initially, empty xanode
> contains reserved place for 8 index keys. First position keeps
> index key that describes xanode itself. It is located leaf keys
> after space that is reserved for index keys. Leaf keys grow
> towards entries. The chain of keys is ended by termination marker
> ("end key"). Entries begin from xanode end and its grow from the
> end towards "end key".
> 
> Thereby, xanode can be a mixture of index keys with [leaf key;
> entry] pairs or it can contain only index keys. A xanode can
> contain [8 | 16 | 32 |...| and so on] index keys. Firstly, when
> inode has only one xanode in a tree then it hasn't any necessity
> in index keys. First xanode in tree will keep index keys for
> 8 xanode are added after first one. Then number of index keys in
> first xanode will be increased while first xanode is became
> index xanode completely. Thereby, an inode keeps ID number of
> first xanode in the tree and reading first xanode gives knowledge
> about the next leaf node on the basis of index keys or searching
> xattr (if first xanode keeps entries yet). Finally, after
> exhausting of first inode by index keys, index keys are stored
> in xanodes are described in first xanode, and so on.
> 
> /* Magic number of xafile node */
> #define NILFS_XANODE_MAGIC              0x5841 /* XA */
> 
> /* Xafile node's types */
> #define NILFS_INLINE_XANODE_TYPE        0
> #define NILFS_SHARED_XANODE_TYPE        1
> #define NILFS_TREE_XANODE_TYPE          2
> 
> /*
>  * struct nilfs_inline_xanode_header - header of inline node
>  * @magic: magic number for identification
>  * @type: node type
>  * @entries: number of entries in node
>  * @log_node_size: log2(node size in bytes)
>  * @flags: node flags
>  */
> struct nilfs_inline_xanode_header {
>         __le16 magic;
>         u8 type : 2;
>         u8 entries : 6;
>         u8 log_node_size : 4;
>         u8 flags : 4;
> } __packed;
> 
> /*
>  * struct nilfs_shared_xanode_header - header of shared xanode
>  * @magic: magic number for identification
>  * @type: node type
>  * @entries_low: low 6 bits of entries number in a node
>  * @log_node_size: log2(node size in bytes)
>  * @reserved1: reserved field
>  * @flags: node flags
>  * @entries_high: high 8 bits of entries number in a node
>  * @refcount: node's reference count
>  * @checksum: CRC32 of node
>  * @hash: hash value of all attributes
>  * @reserved2: reserved field
>  */
> struct nilfs_shared_xanode_header {
>         __le16 magic;
>         u8 type : 2;
>         u8 entries_low : 6;
>         u8 log_node_size : 4;
>         u8 reserved1 : 4;
>         u8 flags;
>         u8 entries_high;
>         __le16 refcount;
>         __le32 checksum;
>         __le32 hash;
>         u8 reserved2[16];
> } __packed;
> 
> /*
>  * struct nilfs_tree_xanode_header - header of dedicated xanode
>  * @magic: magic number for identification
>  * @type: node type
>  * @entries_low: low 6 bits of entries number in a node
>  * @log_node_size: log2(node size in bytes)
>  * @log_index_keys: log2(index keys max count)
>  * @flags: node flags
>  * @entries_high: high 8 bits of entries number in a node
>  * @height: node height in the tree
>  * @index_keys_low: low 4 bits of current index keys count
>  * @index_keys_high: high 8 bits of current index keys count
>  * @checksum: CRC32 of node
>  * @prev: previous node ID number
>  * @next: next node ID number
>  * @reserved: reserved field
>  */
> struct nilfs_tree_xanode_header {
>         __le16 magic;
>         u8 type : 2;
>         u8 entries_low : 6;
>         u8 log_node_size : 4;
>         u8 log_index_keys : 4;
>         u8 flags;
>         u8 entries_high;
>         u8 height : 4;
>         u8 index_keys_low : 4;
>         u8 index_keys_high;
>         __le32 checksum;
>         __le64 prev;
>         __le64 next;
>         __le32 reserved;
> } __packed;
> 
> /* Xattr key's flags */
> #define NILFS_INLINE_NODE_KEY           0
> #define NILFS_SHARED_XANODE_KEY         1
> #define NILFS_XANODE_INDEX_KEY          2
> #define NILFS_XANODE_LEAF_KEY           3
> 
> /*
>  * struct nilfs_xattr_inline_key - xattr key for inline node
>  * @type: key type
>  * @flags: key's flags
>  * @reserved: reserved field
>  * @name_index: attribute name index
>  * @name_hash: name hash
>  * @entry_offset: entry offset inside the node
>  * @entry_size: size of entry in bytes
>  */
> struct nilfs_xattr_inline_key {
>         u8 type : 2;
>         u8 flags : 6;
>         u8 reserved;
>         __le16 name_index;
>         __le32 name_hash;
>         __le16 entry_offset;
>         __le16 entry_size;
> } __packed;
> 
> /*
>  * struct nilfs_xattr_shared_key - xattr key for shared node
>  * @type: key type
>  * @flags: key's flags
>  * @reserved1: reserved field
>  * @name_index: attribute name index
>  * @name_hash: name hash
>  * @entry_offset: entry offset inside the node
>  * @entry_size: size of entry in bytes
>  * @ino: inode ID
>  */
> struct nilfs_xattr_shared_key {
>         u8 type : 2;
>         u8 flags : 6;
>         u8 reserved1;
>         __le16 name_index;
>         __le32 name_hash;
>         __le16 entry_offset;
>         __le16 entry_size;
>         __le64 ino;
> } __packed;
> 
> /*
>  * struct nilfs_xattr_index_key - xattr index key
>  * @type: key type
>  * @flags: key's flags
>  * @reserved1: reserved field
>  * @name_index: attribute name index
>  * @name_hash: name hash
>  * @parent: parent node ID
>  * @leaf: leaf node ID
>  */
> struct nilfs_xattr_index_key {
>         u8 type : 2;
>         u8 flags : 6;
>         u8 reserved1;
>         __le16 name_index;
>         __le32 name_hash;
>         __le64 parent;
>         __le64 leaf;
> } __packed;
> 
> /*
>  * struct nilfs_xattr_leaf_key - xattr leaf key
>  * @type: key type
>  * @flags: key's flags
>  * @reserved1: reserved field
>  * @name_index: attribute name index
>  * @name_hash: name hash
>  * @entry_offset: entry offset inside the node
>  * @entry_size: size of entry in bytes
>  */
> struct nilfs_xattr_leaf_key {
>         u8 type : 2;
>         u8 flags : 6;
>         u8 reserved1;
>         __le16 name_index;
>         __le32 name_hash;
>         __le16 entry_offset;
>         __le16 entry_size;
> } __packed;
> 
> /*
>  *   Structure of xafile's node entry:
>  *
>  *   ---------------------------------------------------
>  *   | name_len | name[variable_length] | binary value |
>  *   ---------------------------------------------------
>  *   |<----------------   entry_size  ---------------->|
>  *
>  *   The xafile's node entry begins with name_len field
>  *   that define length of xattr name. Then it follows
>  *   name's symbol chain. Entry is ended by xattr value.
>  *   The whole entry's size is defined by entry_size
>  *   field of the key structure.
>  */
> 
> /*
>  * struct nilfs_xattr_entry - entry of xafile's node
>  * @name_len: name length
>  * @name: attribute name
>  */
> struct nilfs_xattr_entry {
>         __le16 name_len;
>         char name[0];
> } __packed;
> 
> So, I hope that this portion of information gives whole picture of the
> implementation idea.
> 
> With the best regards,
> Vyacheslav Dubeyko.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
