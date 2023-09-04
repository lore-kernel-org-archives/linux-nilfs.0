From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 07/11] vfs: add nowait parameter for file_accessed()
Date: Mon, 4 Sep 2023 11:51:40 +0200
Message-ID: <20230904-trennen-gewettert-0b2dc5ba60bc@brauner>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
 <20230827132835.1373581-8-hao.xu@linux.dev>
Mime-Version: 1.0
Return-path: <ecryptfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693821110;
        bh=u+xgETcg23UcZvAsSNoTKQTpoQDzWhh5CjfKLhaLfCA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GrBGNC0GUAEP92SVXDSYgvIeyQhEWu5ohv1UZxcq2j4jmPnZMVKVXd7PcLbrec+YC
         YwtxwrDnv2HUbxAauD5LP+iZpv1hgd3J7v5N5AFier00fzuLYjkXSyalNCln662qcL
         MOkKZFmfbFH61oxgNm/1PDUalOPIF/dG8en4lktLAOJKNet2WlaOi4SDB1WMRo8c1E
         Fx1ryvNUFvNi9qlIPKbaeTXq/1cJbp6vtXGsOglG9wRy2wFIevByTxjIps/B3VRZZs
         ZTGcqJO6bRRRPVV2zC3wt54/lylE+o7sVECKL3QKI1/oWONjJaYkFRkcM0vOKzehKT
         ynVVLBmYA4BCQ==
Content-Disposition: inline
In-Reply-To: <20230827132835.1373581-8-hao.xu@linux.dev>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Xu <hao.xu@linux.dev>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Dominique Martinet <asmadeus@codewreck.org>, Pavel Begunkov <asml.silence@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>, Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cachefs@redhat.com, ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, codalist@coda.cs.cmu.edu, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-m

On Sun, Aug 27, 2023 at 09:28:31PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Add a boolean parameter for file_accessed() to support nowait semantics.
> Currently it is true only with io_uring as its initial caller.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>  arch/s390/hypfs/inode.c | 2 +-
>  block/fops.c            | 2 +-
>  fs/btrfs/file.c         | 2 +-
>  fs/btrfs/inode.c        | 2 +-
>  fs/coda/dir.c           | 4 ++--
>  fs/ext2/file.c          | 4 ++--
>  fs/ext4/file.c          | 6 +++---
>  fs/f2fs/file.c          | 4 ++--
>  fs/fuse/dax.c           | 2 +-
>  fs/fuse/file.c          | 4 ++--
>  fs/gfs2/file.c          | 2 +-
>  fs/hugetlbfs/inode.c    | 2 +-
>  fs/nilfs2/file.c        | 2 +-
>  fs/orangefs/file.c      | 2 +-
>  fs/orangefs/inode.c     | 2 +-
>  fs/pipe.c               | 2 +-
>  fs/ramfs/file-nommu.c   | 2 +-
>  fs/readdir.c            | 2 +-
>  fs/smb/client/cifsfs.c  | 2 +-
>  fs/splice.c             | 2 +-
>  fs/ubifs/file.c         | 2 +-
>  fs/udf/file.c           | 2 +-
>  fs/xfs/xfs_file.c       | 6 +++---
>  fs/zonefs/file.c        | 4 ++--
>  include/linux/fs.h      | 5 +++--
>  mm/filemap.c            | 8 ++++----
>  mm/shmem.c              | 6 +++---
>  27 files changed, 43 insertions(+), 42 deletions(-)
> 
> diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
> index ee919bfc8186..55f562027c4f 100644
> --- a/arch/s390/hypfs/inode.c
> +++ b/arch/s390/hypfs/inode.c
> @@ -157,7 +157,7 @@ static ssize_t hypfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  	if (!count)
>  		return -EFAULT;
>  	iocb->ki_pos = pos + count;
> -	file_accessed(file);
> +	file_accessed(file, false);

Why? If all you do is skip atime update anyway then just add something
like:

bool file_needs_atime(struct file *file)
{
       return !(file->f_flags & O_NOATIME) &&
              atime_needs_update(&file->f_path, d_inode(path->dentry));
}

and then

if (file_needs_atime(file) && IOURING_WANTS_ASYNC)
	return -EAGAIN;

instead of touching all this code.
