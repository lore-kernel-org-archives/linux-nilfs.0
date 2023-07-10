From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v2 00/92] fs: new accessors for inode->i_ctime
Date: Mon, 10 Jul 2023 14:18:51 +0200
Message-ID: <20230710-stift-flexibel-0867d393e8fa@brauner>
References: <20230705185812.579118-1-jlayton@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <ecryptfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688991587;
        bh=2J+fX1q6zGco9Qkkut7k1oGUom0kvdTsmG/UR5nBS/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcZg/5Hf6Blw0S0KBVmLS7XuB4wH3HsrCXsC5h2hKYACqGAETSqwGiuAn1zv2/Rsl
         YOfRjkeYMFIcaW7p23OxWcTEiGLmzVZP8u7MfCw251UdZXm1FaRYowg+5pVNRUg4SH
         rGbxakRBAw9Je/7IcFdyUw/AWroEm+9K1nQHsFNnUlEt3jB8MrvNjS2zRswA08V8pZ
         wds+9xHOVtRXpxw7AKs0S8ikoHFutTN5KKOCQTdSntzEeWNrOBLYZvNJ58I4jWKMO4
         trOiZmcTQJEaQV42w0QGQ4l/lY6Yv8dXtuTOWkUkO0al5gZVMemGZipC4IDHXdVMiv
         89FE2RmemJaUA==
In-Reply-To: <20230705185812.579118-1-jlayton@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=11283; i=brauner@kernel.org; h=from:subject:message-id; bh=2J+fX1q6zGco9Qkkut7k1oGUom0kvdTsmG/UR5nBS/g=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaSs/vZNcyJHQ0Srmfqv55c3nchaqnLhiXDZo5JbRxU5e1cl n+5y6yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIeSLDPw3jLbFNd8SdNfmWvzKRN5 4i/XfC34/Ccjwx+uq6O0V4vRgZbnS7HzHcMNt5f8KEj277edSLOHh1Hm9NW7nW7fLG/4kybAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, jk@ozlabs.org, arnd@arndb.de, mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com, gregkh@linuxfoundation.org, arve@android.com, tkjos@android.com, maco@android.com, joel@joelfernandes.org, cmllamas@google.com, surenb@google.com, dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca, leon@kernel.org, bwarrum@linux.ibm.com, rituagar@linux.ibm.com, ericvh@kernel.org, lucho@ionkov.net, asmadeus@codewreck.org, linux_oss@crudebyte.com, dsterba@suse.com, dhowells@redhat.com, marc.dionne@auristor.com, viro@zeniv.linux.org.uk, raven@themaw.net, luisbg@kernel.org, salah.triki@gmail.com, aivazian.tigran@gmail.com, ebiederm@xmissi

On Wed, 05 Jul 2023 14:58:09 -0400, Jeff Layton wrote:
> v2:
> - prepend patches to add missing ctime updates
> - add simple_rename_timestamp helper function
> - rename ctime accessor functions as inode_get_ctime/inode_set_ctime_*
> - drop individual inode_ctime_set_{sec,nsec} helpers
> 
> I've been working on a patchset to change how the inode->i_ctime is
> accessed in order to give us conditional, high-res timestamps for the
> ctime and mtime. struct timespec64 has unused bits in it that we can use
> to implement this. In order to do that however, we need to wrap all
> accesses of inode->i_ctime to ensure that bits used as flags are
> appropriately handled.
> 
> [...]

Applied to the vfs.ctime branch of the vfs/vfs.git tree.
Patches in the vfs.ctime branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.ctime

[01/92] ibmvmc: update ctime in conjunction with mtime on write
        https://git.kernel.org/vfs/vfs/c/ead310563ad2
[02/92] bfs: update ctime in addition to mtime when adding entries
        https://git.kernel.org/vfs/vfs/c/f42faf14b838
[03/92] efivarfs: update ctime when mtime changes on a write
        https://git.kernel.org/vfs/vfs/c/d8d026e0d1f2
[04/92] exfat: ensure that ctime is updated whenever the mtime is
        https://git.kernel.org/vfs/vfs/c/d84bd8fa48d7
[05/92] apparmor: update ctime whenever the mtime changes on an inode
        https://git.kernel.org/vfs/vfs/c/73955caedfae
[06/92] cifs: update the ctime on a partial page write
        https://git.kernel.org/vfs/vfs/c/c2f784379c99
[07/92] fs: add ctime accessors infrastructure
        https://git.kernel.org/vfs/vfs/c/64f0367de800
[08/92] fs: new helper: simple_rename_timestamp
        https://git.kernel.org/vfs/vfs/c/54ced54a0239
[09/92] btrfs: convert to simple_rename_timestamp
        https://git.kernel.org/vfs/vfs/c/218e0f662fee
[10/92] ubifs: convert to simple_rename_timestamp
        https://git.kernel.org/vfs/vfs/c/caac4f65568d
[11/92] shmem: convert to simple_rename_timestamp
        https://git.kernel.org/vfs/vfs/c/d3d11e9927b6
[12/92] exfat: convert to simple_rename_timestamp
        https://git.kernel.org/vfs/vfs/c/71534b484c63
[13/92] ntfs3: convert to simple_rename_timestamp
        https://git.kernel.org/vfs/vfs/c/140880821ce0
[14/92] reiserfs: convert to simple_rename_timestamp
        https://git.kernel.org/vfs/vfs/c/1a1a4df5e8fc
[15/92] spufs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/784e5a93c9cf
[16/92] s390: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/1cece1f8e5c2
[17/92] binderfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/0bcd830a76f3
[18/92] infiniband: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/811f97f80b01
[19/92] ibm: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/b447ed7597f0
[20/92] usb: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/2557dc7f2dde
[21/92] 9p: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/4cd4b11385ef
[22/92] adfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/e257d7ade66e
[23/92] affs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/770619f19a77
[24/92] afs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/758506e44668
[25/92] fs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/a0a5a9810b37
[26/92] autofs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/d7d1363cc3f6
[27/92] befs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/d6218773de2d
[28/92] bfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/368b313ac2ab
[29/92] btrfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/d3d15221956a
[30/92] ceph: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/818fc6e0129a
[31/92] coda: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/4e0b22fbc012
[32/92] configfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/69c977798a6a
[33/92] cramfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/911f086eae23
[34/92] debugfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/634a50390dbb
[35/92] devpts: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/92bb29a24707
[36/92] ecryptfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/16d21856dfd6
[37/92] efivarfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/cfeee05a50e1
[38/92] efs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/3a30b097319f
[39/92] erofs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/e3594996216f
[40/92] exfat: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/8bd562d6f46d
[41/92] ext2: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/7483252e8894
[42/92] ext4: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/f2ddb05870fb
[43/92] 9afc475653af f2fs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/f2ddb05870fb
[44/92] fat: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/8a0c417b695b
[45/92] freevxfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/7affaeb5b914
[46/92] fuse: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/688279761436
[47/92] gfs2: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/9e5b114b5ee4
[48/92] hfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/d41f5876a177
[49/92] hfsplus: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/147f3dd171d2
[50/92] hostfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/2ceaa835b4f5
[51/92] hpfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/e6fd7f49daa7
[52/92] hugetlbfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/f5950f079b1a
[53/92] isofs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/53f2bb3567f0
[54/92] jffs2: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/7e8dc4ab1afb
[55/92] jfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/77737373dbb3
[56/92] kernfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/8b0e3c2e9900
[57/92] nfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/12844cb15dc6
[58/92] nfsd: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/f297728268bf
[59/92] nilfs2: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/1e9f083bc9cd
[60/92] ntfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/3cc66672eaa5
[61/92] ntfs3: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/9438de01396e
[62/92] ocfs2: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/da5b97da32e7
[63/92] omfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/563d772c8d70
[64/92] openpromfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/5f0978a6f0a6
[65/92] orangefs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/6a83804b4325
[66/92] overlayfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/60dcee636746
[67/92] procfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/85e0a6b3b8cf
[68/92] pstore: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/2b8125b5e7c6
[69/92] qnx4: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/77eb00659cb5
[70/92] qnx6: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/af1acd38df36
[71/92] ramfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/0eb8012f4b0b
[72/92] reiserfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/e3e5f5f70292
[73/92] romfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/b6058a9af143
[74/92] smb: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/d5c263f2187d
[75/92] squashfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/eaace9c73ba8
[76/92] sysv: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/41b6f4fbbe32
[77/92] tracefs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/5f69a5364568
[78/92] ubifs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/5bb225ba81c0
[79/92] udf: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/e251f0e98433
[80/92] ufs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/376ef9f6cab1
[81/92] vboxsf: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/9f06612951d5
[82/92] xfs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/4e8c1361146f
[83/92] zonefs: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/cbdc6aa5f65d
[84/92] linux: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/ff12abb4a71a
[85/92] mqueue: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/a6b5a0055142
[86/92] bpf: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/d2b6a0a3863a
[87/92] shmem: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/ffcd778237d3
[88/92] sunrpc: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/ccf1c9002d71
[89/92] apparmor: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/ff91aaa76f1a
[90/92] security: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/701071f9ad33
[91/92] selinux: convert to ctime accessor functions
        https://git.kernel.org/vfs/vfs/c/cb6dfffdc7e9
[92/92] fs: rename i_ctime field to __i_ctime
        https://git.kernel.org/vfs/vfs/c/c06d4bf5e207
