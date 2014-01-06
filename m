From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: add comments for ioctls
Date: Tue, 07 Jan 2014 03:54:25 +0900 (JST)
Message-ID: <20140107.035425.27800352.konishi.ryusuke@lab.ntt.co.jp>
References: <1389012741.3691.2.camel@slavad-ubuntu-12.04>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389012741.3691.2.camel-dzAnj6fV1RxGeWtTaGDT1UEK6ufn8VP3@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hi Vyacheslav,
On Mon, 06 Jan 2014 16:52:21 +0400, Vyacheslav Dubeyko wrote:
> From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> Subject: [PATCH] nilfs2: add comments for ioctls
> 
> This patch adds comments for ioctls in fs/nilfs2/ioctl.c
> file and describes NILFS2 specific ioctls in documentation
> file Documentation/filesystems/nilfs2.txt.
> 
> Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Thanks for this.  I'll add a few comments in-line below.

> ---
>  Documentation/filesystems/nilfs2.txt |   54 +++++
>  fs/nilfs2/ioctl.c                    |  357 +++++++++++++++++++++++++++++++++-
>  2 files changed, 410 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/nilfs2.txt b/Documentation/filesystems/nilfs2.txt
> index 873a2ab..1fc46d1 100644
> --- a/Documentation/filesystems/nilfs2.txt
> +++ b/Documentation/filesystems/nilfs2.txt
> @@ -81,6 +81,60 @@ nodiscard(*)		The discard/TRIM commands are sent to the underlying
>  			block device when blocks are freed.  This is useful
>  			for SSD devices and sparse/thinly-provisioned LUNs.
>  
> +Ioctls
> +======
> +
> +There is some NILFS2 specific functionality which can be accessed by applications
> +through the system call interfaces. The list of all NILFS2 specific ioctls are
> +shown in the table below.
> +
> +Table of NILFS2 specific ioctls
> +..............................................................................
> + Ioctl			        Description
> + NILFS_IOCTL_CHANGE_CPMODE      Change mode of given checkpoint between
> +			        checkpoint and snapshot state. This ioctl is
> +			        used in chcp and mkcp utilities.
> +
> + NILFS_IOCTL_DELETE_CHECKPOINT  Remove checkpoint from NILFS2 file system.
> +			        This ioctl is used in rmcp utility.
> +
> + NILFS_IOCTL_GET_CPINFO         Return info about requested checkpoints. This
> +			        ioctl is used in lscp utility and by
> +			        nilfs_cleanerd daemon.
> +
> + NILFS_IOCTL_GET_CPSTAT         Return checkpoints statistics. This ioctl is
> +			        used by lscp, rmcp utilities and by
> +			        nilfs_cleanerd daemon.
> +
> + NILFS_IOCTL_GET_SUINFO         Return segment usage info about requested
> +			        segments. This ioctl is used in lssu,
> +			        nilfs_resize utilities and by nilfs_cleanerd
> +			        daemon.
> +
> + NILFS_IOCTL_GET_SUSTAT         Return segment usage statistics. This ioctl
> +			        is used in lssu, nilfs_resize utilities and
> +			        by nilfs_cleanerd daemon.
> +
> + NILFS_IOCTL_GET_VINFO          Return information on virtual block addresses.
> +			        This ioctl is used by nilfs_cleanerd daemon.
> +
> + NILFS_IOCTL_GET_BDESCS         Return information about descriptors of disk
> +			        block numbers. This ioctl is used by
> +			        nilfs_cleanerd daemon.
> +
> + NILFS_IOCTL_CLEAN_SEGMENTS     Do garbage collection operation in the
> +			        environment of requested parameters from
> +			        userspace. This ioctl is used by
> +			        nilfs_cleanerd daemon.
> +
> + NILFS_IOCTL_SYNC               Construct logical segment.

I think "Make a checkpoint" is more appropriate for the summary of
this ioctl.  You can add "This ioctl is used in mkcp utility." if you
follow descriptions of other ioctls.

> +
> + NILFS_IOCTL_RESIZE             Resize NILFS2 volume.
> +
> + NILFS_IOCTL_SET_ALLOC_RANGE    Define lower limit of segments in bytes and
> +			        upper limit of segments in bytes. This ioctl
> +			        is used by nilfs_resize utility.
> +
>  NILFS2 usage
>  ============
>  
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index b44bdb2..6152b2a 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -37,7 +37,26 @@
>  #include "sufile.h"
>  #include "dat.h"
>  
> -
> +/**
> + * nilfs_ioctl_wrap_copy - wrapping function of get/set metadata info
> + * @nilfs: nilfs object
> + * @argv: vector of arguments from userspace
> + * @dir: set of direction flags
> + * @dofunc: concrete function of get/set metadata info
> + *
> + * Description: nilfs_ioctl_wrap_copy() gets/sets metadata info by means of
> + * calling dofunc() function on the basis of @argv argument.
> + *
> + * Return Value: On success, 0 is returned and requested metadata info
> + * is copied into userspace. On error, one of the following
> + * negative error codes is returned.
> + *
> + * %-EINVAL - Invalid arguments from userspace.
> + *
> + * %-ENOMEM - Insufficient amount of memory available.
> + *
> + * %-EFAULT - Failure during execution of requested operation.
> + */
>  static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
>  				 struct nilfs_argv *argv, int dir,
>  				 ssize_t (*dofunc)(struct the_nilfs *,
> @@ -99,6 +118,9 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
>  	return ret;
>  }
>  
> +/**
> + * nilfs_ioctl_getflags - ioctl to support lsattr
> + */
>  static int nilfs_ioctl_getflags(struct inode *inode, void __user *argp)
>  {
>  	unsigned int flags = NILFS_I(inode)->i_flags & FS_FL_USER_VISIBLE;
> @@ -106,6 +128,9 @@ static int nilfs_ioctl_getflags(struct inode *inode, void __user *argp)
>  	return put_user(flags, (int __user *)argp);
>  }
>  
> +/**
> + * nilfs_ioctl_setflags - ioctl to support chattr
> + */
>  static int nilfs_ioctl_setflags(struct inode *inode, struct file *filp,
>  				void __user *argp)
>  {
> @@ -158,11 +183,33 @@ out:
>  	return ret;
>  }
>  
> +/**
> + * nilfs_ioctl_getversion - get info about a file's version (generation number)
> + */
>  static int nilfs_ioctl_getversion(struct inode *inode, void __user *argp)
>  {
>  	return put_user(inode->i_generation, (int __user *)argp);
>  }
>  
> +/**
> + * nilfs_ioctl_change_cpmode - change checkpoint mode (checkpoint/snapshot)
> + * @inode: inode object
> + * @filp: file object
> + * @cmd: ioctl's request code
> + * @argp: pointer on argument from userspace
> + *
> + * Description: nilfs_ioctl_change_cpmode() function changes mode of
> + * given checkpoint between checkpoint and snapshot state. This ioctl
> + * is used in chcp and mkcp utilities.
> + *
> + * Return Value: On success, 0 is returned and mode of a checkpoint is
> + * changed. On error, one of the following negative error codes
> + * is returned.
> + *
> + * %-EPERM - Operation not permitted.
> + *
> + * %-EFAULT - Failure during checkpoint mode changing.
> + */
>  static int nilfs_ioctl_change_cpmode(struct inode *inode, struct file *filp,
>  				     unsigned int cmd, void __user *argp)
>  {
> @@ -198,6 +245,25 @@ out:
>  	return ret;
>  }
>  
> +/**
> + * nilfs_ioctl_delete_checkpoint - remove checkpoint
> + * @inode: inode object
> + * @filp: file object
> + * @cmd: ioctl's request code
> + * @argp: pointer on argument from userspace
> + *
> + * Description: nilfs_ioctl_delete_checkpoint() function removes
> + * checkpoint from NILFS2 file system. This ioctl is used in rmcp
> + * utility.
> + *
> + * Return Value: On success, 0 is returned and a checkpoint is
> + * removed. On error, one of the following negative error codes
> + * is returned.
> + *
> + * %-EPERM - Operation not permitted.
> + *
> + * %-EFAULT - Failure during checkpoint removing.
> + */
>  static int
>  nilfs_ioctl_delete_checkpoint(struct inode *inode, struct file *filp,
>  			      unsigned int cmd, void __user *argp)
> @@ -229,6 +295,21 @@ out:
>  	return ret;
>  }
>  
> +/**
> + * nilfs_ioctl_do_get_cpinfo - callback method getting info about checkpoints
> + * @nilfs: nilfs object
> + * @posp: pointer on array of checkpoint's numbers
> + * @flags: checkpoint mode (checkpoint or snapshot)
> + * @buf: buffer for storing checkponts' info
> + * @size: size in bytes of one checkpoint info item in array
> + * @nmembs: number of checkpoints in array (numbers and infos)
> + *
> + * Description: nilfs_ioctl_do_get_cpinfo() function returns info about
> + * requested checkpoints. The NILFS_IOCTL_GET_CPINFO ioctl is used in
> + * lscp utility and by nilfs_cleanerd daemon.
> + *
> + * Return value: count of nilfs_cpinfo structures in output buffer.
> + */
>  static ssize_t
>  nilfs_ioctl_do_get_cpinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
>  			  void *buf, size_t size, size_t nmembs)
> @@ -242,6 +323,27 @@ nilfs_ioctl_do_get_cpinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
>  	return ret;
>  }
>  
> +/**
> + * nilfs_ioctl_get_cpstat - get checkpoints statistics
> + * @inode: inode object
> + * @filp: file object
> + * @cmd: ioctl's request code
> + * @argp: pointer on argument from userspace
> + *
> + * Description: nilfs_ioctl_get_cpstat() returns information about checkpoints.
> + * The NILFS_IOCTL_GET_CPSTAT ioctl is used by lscp, rmcp utilities
> + * and by nilfs_cleanerd daemon.
> + *
> + * Return Value: On success, 0 is returned, and checkpoints information is
> + * copied into userspace pointer @argp. On error, one of the following
> + * negative error codes is returned.
> + *
> + * %-EIO - I/O error.
> + *
> + * %-ENOMEM - Insufficient amount of memory available.
> + *
> + * %-EFAULT - Failure during getting checkpoints statistics.
> + */
>  static int nilfs_ioctl_get_cpstat(struct inode *inode, struct file *filp,
>  				  unsigned int cmd, void __user *argp)
>  {
> @@ -260,6 +362,21 @@ static int nilfs_ioctl_get_cpstat(struct inode *inode, struct file *filp,
>  	return ret;
>  }
>  
> +/**
> + * nilfs_ioctl_do_get_suinfo - callback method getting segment usage info
> + * @nilfs: nilfs object
> + * @posp: pointer on array of segment numbers
> + * @flags: *not used*
> + * @buf: buffer for storing suinfo array
> + * @size: size in bytes of one suinfo item in array
> + * @nmembs: count of segment numbers and suinfos in array
> + *
> + * Description: nilfs_ioctl_do_get_suinfo() function returns segment usage
> + * info about requested segments. The NILFS_IOCTL_GET_SUINFO ioctl is used
> + * in lssu, nilfs_resize utilities and by nilfs_cleanerd daemon.
> + *
> + * Return value: count of nilfs_suinfo structures in output buffer.
> + */
>  static ssize_t
>  nilfs_ioctl_do_get_suinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
>  			  void *buf, size_t size, size_t nmembs)
> @@ -273,6 +390,27 @@ nilfs_ioctl_do_get_suinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
>  	return ret;
>  }
>  
> +/**
> + * nilfs_ioctl_get_sustat - get segment usage statistics
> + * @inode: inode object
> + * @filp: file object
> + * @cmd: ioctl's request code
> + * @argp: pointer on argument from userspace
> + *
> + * Description: nilfs_ioctl_get_sustat() returns segment usage statistics.
> + * The NILFS_IOCTL_GET_SUSTAT ioctl is used in lssu, nilfs_resize utilities
> + * and by nilfs_cleanerd daemon.
> + *
> + * Return Value: On success, 0 is returned, and segment usage information is
> + * copied into userspace pointer @argp. On error, one of the following
> + * negative error codes is returned.
> + *
> + * %-EIO - I/O error.
> + *
> + * %-ENOMEM - Insufficient amount of memory available.
> + *
> + * %-EFAULT - Failure during getting segment usage statistics.
> + */
>  static int nilfs_ioctl_get_sustat(struct inode *inode, struct file *filp,
>  				  unsigned int cmd, void __user *argp)
>  {
> @@ -291,6 +429,21 @@ static int nilfs_ioctl_get_sustat(struct inode *inode, struct file *filp,
>  	return ret;
>  }
>  
> +/**
> + * nilfs_ioctl_do_get_vinfo - callback method getting virtual blocks info
> + * @nilfs: nilfs object
> + * @posp: *not used*
> + * @flags: *not used*
> + * @buf: buffer for storing array of nilfs_vinfo structures
> + * @size: size in bytes of one vinfo item in array
> + * @nmembs: count of vinfos in array
> + *
> + * Description: nilfs_ioctl_do_get_vinfo() function returns information
> + * on virtual block addresses. The NILFS_IOCTL_GET_VINFO ioctl is used
> + * by nilfs_cleanerd daemon.
> + *
> + * Return value: count of nilfs_vinfo structures in output buffer.
> + */
>  static ssize_t
>  nilfs_ioctl_do_get_vinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
>  			 void *buf, size_t size, size_t nmembs)
> @@ -303,6 +456,21 @@ nilfs_ioctl_do_get_vinfo(struct the_nilfs *nilfs, __u64 *posp, int flags,
>  	return ret;
>  }
>  
> +/**
> + * nilfs_ioctl_do_get_bdescs - callback method getting disk block descriptors
> + * @nilfs: nilfs object
> + * @posp: *not used*
> + * @flags: *not used*
> + * @buf: buffer for storing array of nilfs_bdesc structures
> + * @size: size in bytes of one bdesc item in array
> + * @nmembs: count of bdescs in array
> + *
> + * Description: nilfs_ioctl_do_get_bdescs() function returns information
> + * about descriptors of disk block numbers. The NILFS_IOCTL_GET_BDESCS ioctl
> + * is used by nilfs_cleanerd daemon.
> + *
> + * Return value: count of nilfs_bdescs structures in output buffer.
> + */
>  static ssize_t
>  nilfs_ioctl_do_get_bdescs(struct the_nilfs *nilfs, __u64 *posp, int flags,
>  			  void *buf, size_t size, size_t nmembs)
> @@ -329,6 +497,29 @@ nilfs_ioctl_do_get_bdescs(struct the_nilfs *nilfs, __u64 *posp, int flags,
>  	return nmembs;
>  }
>  
> +/**
> + * nilfs_ioctl_get_bdescs - get disk block descriptors
> + * @inode: inode object
> + * @filp: file object
> + * @cmd: ioctl's request code
> + * @argp: pointer on argument from userspace
> + *
> + * Description: nilfs_ioctl_do_get_bdescs() function returns information
> + * about descriptors of disk block numbers. The NILFS_IOCTL_GET_BDESCS ioctl
> + * is used by nilfs_cleanerd daemon.
> + *
> + * Return Value: On success, 0 is returned, and disk block descriptors are
> + * copied into userspace pointer @argp. On error, one of the following
> + * negative error codes is returned.
> + *
> + * %-EINVAL - Invalid arguments from userspace.
> + *
> + * %-EIO - I/O error.
> + *
> + * %-ENOMEM - Insufficient amount of memory available.
> + *
> + * %-EFAULT - Failure during getting disk block descriptors.
> + */
>  static int nilfs_ioctl_get_bdescs(struct inode *inode, struct file *filp,
>  				  unsigned int cmd, void __user *argp)
>  {
> @@ -352,6 +543,26 @@ static int nilfs_ioctl_get_bdescs(struct inode *inode, struct file *filp,
>  	return ret;
>  }
>  
> +/**
> + * nilfs_ioctl_move_inode_block - prepare data/node block for moving by GC
> + * @inode: inode object
> + * @vdesc: descriptor of virtual block number
> + * @buffers: list of moving buffers
> + *
> + * Description: nilfs_ioctl_move_inode_block() function registers data/node
> + * buffer in the GC pagecache and submit read request.
> + *
> + * Return Value: On success, 0 is returned. On error, one of the following
> + * negative error codes is returned.
> + *
> + * %-EIO - I/O error.
> + *
> + * %-ENOMEM - Insufficient amount of memory available.
> + *
> + * %-ENOENT - Requested block doesn't exist.
> + *
> + * %-EEXIST - Blocks conflict is detected.
> + */
>  static int nilfs_ioctl_move_inode_block(struct inode *inode,
>  					struct nilfs_vdesc *vdesc,
>  					struct list_head *buffers)
> @@ -397,6 +608,18 @@ static int nilfs_ioctl_move_inode_block(struct inode *inode,
>  	return 0;
>  }
>  
> +/**
> + * nilfs_ioctl_move_blocks - move valid inode's blocks during garbage collection
> + * @sb: superblock object
> + * @argv: vector of arguments from userspace
> + * @buf: array of nilfs_vdesc structures
> + *
> + * Description: nilfs_ioctl_move_blocks() function moves valid
> + * blocks of inodes from GC inode list during garbage collection.

How about the following description for this function:

"nilfs_ioctl_move_blocks() function reads valid data/node blocks that
garbage collector specified with the array of nilfs_vdesc structures
and stores them into page caches of GC inodes."

> + *
> + * Return Value: Number of processed nilfs_vdesc structures or
> + * error code, otherwise.
> + */
>  static int nilfs_ioctl_move_blocks(struct super_block *sb,
>  				   struct nilfs_argv *argv, void *buf)
>  {
> @@ -462,6 +685,25 @@ static int nilfs_ioctl_move_blocks(struct super_block *sb,
>  	return ret;
>  }
>  
> +/**
> + * nilfs_ioctl_delete_checkpoints - delete checkpoints
> + * @nilfs: nilfs object
> + * @argv: vector of arguments from userspace
> + * @buf: array of periods of checkpoints numbers
> + *
> + * Description: nilfs_ioctl_delete_checkpoints() function deletes checkpoints
> + * in the period from p_start to p_end, excluding p_end itself. The checkpoints
> + * which have been already deleted are ignored.
> + *
> + * Return Value: Number of processed nilfs_period structures or
> + * error code, otherwise.
> + *
> + * %-EIO - I/O error.
> + *
> + * %-ENOMEM - Insufficient amount of memory available.
> + *
> + * %-EINVAL - invalid checkpoints.
> + */
>  static int nilfs_ioctl_delete_checkpoints(struct the_nilfs *nilfs,
>  					  struct nilfs_argv *argv, void *buf)
>  {
> @@ -479,6 +721,24 @@ static int nilfs_ioctl_delete_checkpoints(struct the_nilfs *nilfs,
>  	return nmembs;
>  }
>  
> +/**
> + * nilfs_ioctl_free_vblocknrs - free virtual block numbers
> + * @nilfs: nilfs object
> + * @argv: vector of arguments from userspace
> + * @buf: array of virtual block numbers
> + *
> + * Description: nilfs_ioctl_free_vblocknrs() function frees
> + * the virtual block numbers specified by @buf and @argv->v_nmembs.
> + *
> + * Return Value: Number of processed virtual block numbers or
> + * error code, otherwise.
> + *
> + * %-EIO - I/O error.
> + *
> + * %-ENOMEM - Insufficient amount of memory available.
> + *
> + * %-ENOENT - The virtual block number have not been allocated.
> + */
>  static int nilfs_ioctl_free_vblocknrs(struct the_nilfs *nilfs,
>  				      struct nilfs_argv *argv, void *buf)
>  {
> @@ -490,6 +750,24 @@ static int nilfs_ioctl_free_vblocknrs(struct the_nilfs *nilfs,
>  	return (ret < 0) ? ret : nmembs;
>  }
>  
> +/**
> + * nilfs_ioctl_mark_blocks_dirty - mark blocks dirty
> + * @nilfs: nilfs object
> + * @argv: vector of arguments from userspace
> + * @buf: array of block descriptors
> + *
> + * Description: nilfs_ioctl_mark_blocks_dirty() function marks
> + * metadata file or data blocks as dirty.
> + *
> + * Return Value: Number of processed block descriptors or
> + * error code, otherwise.
> + *
> + * %-ENOMEM - Insufficient memory available.
> + *
> + * %-EIO - I/O error
> + *
> + * %-ENOENT - the specified block does not exist (hole block)
> + */
>  static int nilfs_ioctl_mark_blocks_dirty(struct the_nilfs *nilfs,
>  					 struct nilfs_argv *argv, void *buf)
>  {
> @@ -571,6 +849,20 @@ int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
>  	return ret;
>  }
>  
> +/**
> + * nilfs_ioctl_clean_segments - clean segments
> + * @inode: inode object
> + * @filp: file object
> + * @cmd: ioctl's request code
> + * @argp: pointer on argument from userspace
> + *
> + * Description: nilfs_ioctl_clean_segments() function makes garbage
> + * collection operation in the environment of requested parameters
> + * from userspace. The NILFS_IOCTL_CLEAN_SEGMENTS ioctl is used by
> + * nilfs_cleanerd daemon.
> + *
> + * Return Value: On success, 0 is returned or error code, otherwise.
> + */
>  static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
>  				      unsigned int cmd, void __user *argp)
>  {
> @@ -682,6 +974,28 @@ out:
>  	return ret;
>  }
>  
> +/**
> + * nilfs_ioctl_sync - construct logical segment

Ditto (-> "make a checkpoint" )

"Description: nilfs_ioctl_sync() function constructs a logical segment
for checkpointing.  This function guarantees that all modified data
and metadata are written out to the device when it successfully
returned."

> + * @inode: inode object
> + * @filp: file object
> + * @cmd: ioctl's request code
> + * @argp: pointer on argument from userspace
> + *
> + * Return Value: On success, 0 is retured. On errors, one of the following
> + * negative error code is returned.
> + *
> + * %-EROFS - Read only filesystem.
> + *
> + * %-EIO - I/O error
> + *
> + * %-ENOSPC - No space left on device (only in a panic state).
> + *
> + * %-ERESTARTSYS - Interrupted.
> + *
> + * %-ENOMEM - Insufficient memory available.
> + *
> + * %-EFAULT - Failure during execution of requested operation.
> + */
>  static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
>  			    unsigned int cmd, void __user *argp)
>  {
> @@ -710,6 +1024,14 @@ static int nilfs_ioctl_sync(struct inode *inode, struct file *filp,
>  	return 0;
>  }
>  
> +/**
> + * nilfs_ioctl_resize - resize NILFS2 volume
> + * @inode: inode object
> + * @filp: file object
> + * @argp: pointer on argument from userspace
> + *
> + * Return Value: On success, 0 is returned or error code, otherwise.
> + */
>  static int nilfs_ioctl_resize(struct inode *inode, struct file *filp,
>  			      void __user *argp)
>  {
> @@ -735,6 +1057,17 @@ out:
>  	return ret;
>  }
>  
> +/**
> + * nilfs_ioctl_set_alloc_range - limit range of segments to be allocated
> + * @inode: inode object
> + * @argp: pointer on argument from userspace
> + *
> + * Decription: nilfs_ioctl_set_alloc_range() function defines lower limit
> + * of segments in bytes and upper limit of segments in bytes.
> + * The NILFS_IOCTL_SET_ALLOC_RANGE is used by nilfs_resize utility.
> + *
> + * Return Value: On success, 0 is returned or error code, otherwise.
> + */
>  static int nilfs_ioctl_set_alloc_range(struct inode *inode, void __user *argp)
>  {
>  	struct the_nilfs *nilfs = inode->i_sb->s_fs_info;
> @@ -767,6 +1100,28 @@ out:
>  	return ret;
>  }
>  
> +/**
> + * nilfs_ioctl_get_info - wrapping function of get metadata info
> + * @inode: inode object
> + * @filp: file object
> + * @cmd: ioctl's request code
> + * @argp: pointer on argument from userspace
> + * @membsz: size of an item in bytes
> + * @dofunc: concrete function of getting metadata info
> + *
> + * Description: nilfs_ioctl_get_info() gets metadata info by means of
> + * calling dofunc() function.
> + *
> + * Return Value: On success, 0 is returned and requested metadata info
> + * is copied into userspace. On error, one of the following
> + * negative error codes is returned.
> + *
> + * %-EINVAL - Invalid arguments from userspace.
> + *
> + * %-ENOMEM - Insufficient amount of memory available.
> + *
> + * %-EFAULT - Failure during execution of requested operation.
> + */
>  static int nilfs_ioctl_get_info(struct inode *inode, struct file *filp,
>  				unsigned int cmd, void __user *argp,
>  				size_t membsz,
> -- 
> 1.7.9.5

Reviewed-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
