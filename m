From: Vyacheslav Dubeyko <slava-2lV3ebY47BVBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC] nilfs2: extended attributes support
Date: Sun, 26 Aug 2012 20:01:44 +0400
Message-ID: <805D2733-5423-4D53-B376-EC494280CF4B@dubeiko.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

I am thinking about support of extended attributes in NILFS2. As I can see, there is reserved inode id for xattr file. I think that xattr file's content can be represented as b-tree. 

Xattr File Structure:
blk +0                                           +1                   +N
+-------------+----------------------+----------------+-----------------+
+ Xattr file  | Xattr b-tree root + Xattr b-tree + Xattr b-tree +
+   header  |        node            +     node        +     node        +
+-------------+---------------------+-----------------+-----------------+

First block of xattr file can keep header of xattr file at the begin. The rest part of first block can keep b-tree root node. 

/*
 * struct nilfs_xattr_file_header - xattr file header.
 * @xfh_magic: xattr file magic number.
 * @xfh_headersum: checksum of xattr file header.
 * @xfh_datasum: checksum of xattr file descriptor blocks.
 * @xfh_bytes: size of xattr file descriptor in bytes.
 * @xfh_flags: flags.
 * @xfh_nblocks: number of blocks in xattr file.
 * @xfh_xattr_cnt: count of extended attributes in xattr file.
 */
struct nilfs_xattr_file_header {
/*0x00*/		__le32 xfh_magic;
			__le32 xfh_headersum;
			__le32 xfh_datasum;
			__le16 xfh_bytes;
			__le16 xfh_flags;
/*0x10*/		__le32 xfh_nblocks;
			__le32 xfh_xattr_cnt;
}; /*0x18*/

After first blocks are placed index/leaf nodes of xattr b-tree. Root or index b-tree node in the first part contains sequence of xattr entry descriptors that are ordered by xattr entry keys. In the second part of node is placed sequence of child node ids.

Xattr B-tree Root/Index Node Structure:
+-----------+----------------------------------+-------------------------------+
+ B-tree   +    Xattr entry descriptors +        B-tree node id         +
+ header +---+--+--+--+---+--+---+----+---+--+--+---+--+--+---+---+
+               + 1 | 2 | 3 | 4 | 5 | 6 | ** | n   + 1 | 2 | 3 | 4 | 5 | 6 | ** | n +
+-----------+---+--+--+--+---+--+---+----+---+--+--+---+--+--+---+---+

/*
 * struct nilfs_xattr_entry_key - xattr entry key.
 * @xek_inode: inode number of object that have extended attribute.
 * @xek_name_hash: hash of extended attribute name.
 */
struct nilfs_xattr_entry_key {
/*0x00*/		__le64 xek_inode;
			__le32 xek_name_hash;
}; /*0x0C*/

/*
 * struct nilfs_xattr_entry_desc - xattr entry descriptor.
 * @xed_key: xattr entry key.
 * @xed_offset: xattr entry offset in bytes from b-tree node's begin.
 */
struct nilfs_xattr_entry_desc {
/*0x00*/		struct nilfs_xattr_entry_key xed_key;
			__le32 xed_offset;
}; /*0x10*/

Xattr b-tree leaf node contains sequence of xattr entry descriptors in the first part. In the second part of the node is placed sequence of xattr records. Each xattr record can have variable length. The xattr entry descriptor contains offset value in bytes that defines distance from node begin to the beginning of xattr record. Every xattr record begins from xattr entry header which defines whole record size in bytes, entry name size in bytes and xattr value size in bytes. It follows xattr entry name after entry header. Then, after xattr entry name, it follows xattr entry value.

Xattr B-tree Leaf Node Structure:
+-----------+---------------------------------+-------------------------------------------+
+ B-tree   +    Xattr entry descriptors +   Xattr entry records                     +
+ header +---+--+--+---+--+--+---+----+-----+-----+----+----+-----+----+-----+
+               + 1 | 2 | 3 | 4 | 5 | 6 | ** | n   + H1 | N1 | V1 | *** | Hn | Nn | Vn +
+-----------+---+--+--+---+--+--+---+----+-----+-----+----+----+-----+----+-----+
H1 - xattr entry header 1
N1 - xattr entry name 1
V1 - xattr entry value 1

/*
 * struct nilfs_xattr_entry_header - xattr entry header.
 * @xeh_rec_len: size in bytes of full xattr record.
 * @xeh_name_len: size in bytes of xattr name.
 * @xeh_value_len: size in bytes of xattr value.
 */
struct nilfs_xattr_entry_header {
/*0x00*/		__le32 xeh_rec_len;
			__le16 xeh_name_len;
			__le16 xeh_value_len;
}; /*0x08*/

/*
 * struct nilfs_xattr_entry - xattr entry header + name (w/o value).
 * @xe_header: xattr entry header.
 * @xe_name: first byte of xattr name.
 */
struct nilfs_xattr_entry {
/*0x00*/		struct nilfs_xattr_entry_header xe_header;
			char xe_name[1];
};

With the best regards,
Vyacheslav Dubeyko.

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
