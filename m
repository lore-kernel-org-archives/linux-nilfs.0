From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/9] Remove bdi_congested() and wb_congested() and related functions
Date: Fri, 28 Jan 2022 07:10:11 +0900
Message-ID: <CAKFNMom4Z76ti4fp69UeKYf0d4x635OR7Q_CjVnBj+vQSuhESg@mail.gmail.com>
References: <164325106958.29787.4865219843242892726.stgit@noble.brown> <164325158955.29787.4769373293473421057.stgit@noble.brown>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pkUjSb/fdfaa3FAu68ePw4JIYSvRfOC6qyjCilb3MLA=;
        b=RZypLcBcYIUdWY9vV42TppO4LaQPblBv+kCbhi7sSIeity0kCuHxjxBkOW+017vQfl
         mGJzLUkiIibnMnTTVFBLt50VetVg1KzsVDl5jUao0XF5T7oAmS+N8pzAB7j2FNpZGYiq
         xbHy2XvQvsScldzehtVeFOoApJ3rHFqpSLvhJxxrFdkCY4SBOyNaqvrt+GIQFpxxuFFh
         CmyJh/SQOY6vLReOapEDPt77zxgz4JT8F/AZF2zWXE0KCoQ1ChkpEBN24khQj5g1i9qq
         aguCWoq8pgm51d0p5z0SrS13R+0j/TGLyIS5NFK+7PHw2xgpowySjWS1of9EUGPSq6jn
         /AOQ==
In-Reply-To: <164325158955.29787.4769373293473421057.stgit-KMjKAoDPBoBHWa5fdsenEw@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ilya Dryomov <idryomov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, "Darrick J. Wong" <djwong-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, LKML <li>

On Thu, Jan 27, 2022 at 11:47 AM NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org> wrote:
>
> These functions are no longer useful as the only bdis that report
> congestion are in ceph, fuse, and nfs.  None of those bdis can be the
> target of the calls in drbd, ext2, nilfs2, or xfs.
>
> Removing the test on bdi_write_contested() in current_may_throttle()
> could cause a small change in behaviour, but only when PF_LOCAL_THROTTLE
> is set.
>
> So replace the calls by 'false' and simplify the code - and remove the
> functions.
>
> Signed-off-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
> ---
>  drivers/block/drbd/drbd_int.h |    3 ---
>  drivers/block/drbd/drbd_req.c |    3 +--
>  fs/ext2/ialloc.c              |    2 --
>  fs/nilfs2/segbuf.c            |   11 -----------
>  fs/xfs/xfs_buf.c              |    3 ---
>  include/linux/backing-dev.h   |   26 --------------------------
>  mm/vmscan.c                   |    4 +---
>  7 files changed, 2 insertions(+), 50 deletions(-)

for nilfs2 bits,

Acked-by: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks,
Ryusuke Konishi
