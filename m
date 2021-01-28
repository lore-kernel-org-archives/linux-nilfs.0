From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH 28/34] zonefs: use bio_new
Date: Thu, 28 Jan 2021 07:25:08 +0000
Message-ID: <BL0PR04MB651467E7A7C6EA542A435DC6E7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
 <20210128071133.60335-29-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <xen-devel-bounces@lists.xenproject.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611818714; x=1643354714;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Fou+4cLJrSCon50d9/Y3lLiRTfP/NjMtM08GVarOK2I=;
  b=ZN1e9qm0NaBGbTkqiNSSMKsdvjrCXX3qeJH1EjxmhlAzG303SMDSpzec
   xPbxHlY2d2WTj6MfXoJUzsZ88YDoaVaGT7vAOIvyOhiKmsOivceX0O8uH
   3r3Zwdfevfy+A8e01+zesI0MaRn0EWY7UcMHVPm5UDpYPFA6cFwJoA1/M
   mZEYWbUfpbNIMeQpj/fECZKXO8rVjuB6iKQvKT8zFjBOIfhtC6P6qQQID
   zzStcWcQUWipJqXKZEgT7w+JOuvJsouoWNbGKKo9QftyRSvqETgRyOCPc
   z5ArCMjdyzxtv3GfbAe/hLlcnGAmnSOxOytnun+xhToZ/VfPs/x+75moX
   g==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jSgQdFikue5ip6XRlyXPzYKx1++P+Hg8uK52x5aYL+k=;
 b=rcbJ6C+1HneLHXguaze5yHNT9VQb6QapqfT7ZimwMdiRf3BlXyrrVQzYvksAWPAeoLwphxgKl+Ck4KCZdN4IwAGa0P2CQi+y7tYyl6GXouJAwGOKdgkHPFo+1nz9iVrAnlGohUMWpVVVahoBL3AsByBgHK6QGOwRfTqnebimXv0=
Content-Language: en-US
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>, "jfs-discussion@lists.sourceforge.net" <jfs-discussion@lists.sourceforge.net>, "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, ocfs2-devel@oss.oracle.c
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>, "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>, "minchan@kernel.org" <minchan@kernel.org>, "ngupta@vflare.org" <ngupta@vflare.org>, "sergey.senozhatsky.work@gmail.com" <sergey.senozhatsky.work@gmail.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "hch@lst.de" <hch@lst.de>, "sagi@grimberg.me" <sagi@grimberg.me>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "tytso@mit.edu" <tytso@mit.edu>, "jaegeuk@kernel.org" <jaegeuk@kernel.org>, "ebiggers@kernel.org" <ebiggers@kernel.org>, "djwong@kernel.org" <djwong@kernel.org>, "shaggy@kernel.org" <shaggy@kernel.org>, konishi.ryusuke

On 2021/01/28 16:15, Chaitanya Kulkarni wrote:=0A=
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
> ---=0A=
>  fs/zonefs/super.c | 6 ++----=0A=
>  1 file changed, 2 insertions(+), 4 deletions(-)=0A=
> =0A=
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c=0A=
> index ab68e27bb322..620d67965a22 100644=0A=
> --- a/fs/zonefs/super.c=0A=
> +++ b/fs/zonefs/super.c=0A=
> @@ -661,6 +661,7 @@ static const struct iomap_dio_ops zonefs_write_dio_op=
s =3D {=0A=
>  =0A=
>  static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_ite=
r *from)=0A=
>  {=0A=
> +	unsigned int op =3D REQ_OP_ZONE_APPEND | REQ_SYNC | REQ_IDLE;=0A=
=0A=
I do not see the point of adding this variable since it is used only for th=
e=0A=
bio_new() call. Pass the op value directly.=0A=
=0A=
>  	struct inode *inode =3D file_inode(iocb->ki_filp);=0A=
>  	struct zonefs_inode_info *zi =3D ZONEFS_I(inode);=0A=
>  	struct block_device *bdev =3D inode->i_sb->s_bdev;=0A=
> @@ -678,15 +679,12 @@ static ssize_t zonefs_file_dio_append(struct kiocb =
*iocb, struct iov_iter *from)=0A=
>  	if (!nr_pages)=0A=
>  		return 0;=0A=
>  =0A=
> -	bio =3D bio_alloc(GFP_NOFS, nr_pages);=0A=
> +	bio =3D bio_new(bdev, zi->i_zsector, op, 0, GFP_NOFS, nr_pages);=0A=
>  	if (!bio)=0A=
>  		return -ENOMEM;=0A=
>  =0A=
> -	bio_set_dev(bio, bdev);=0A=
> -	bio->bi_iter.bi_sector =3D zi->i_zsector;=0A=
>  	bio->bi_write_hint =3D iocb->ki_hint;=0A=
>  	bio->bi_ioprio =3D iocb->ki_ioprio;=0A=
> -	bio->bi_opf =3D REQ_OP_ZONE_APPEND | REQ_SYNC | REQ_IDLE;=0A=
>  	if (iocb->ki_flags & IOCB_DSYNC)=0A=
>  		bio->bi_opf |=3D REQ_FUA;=0A=
>  =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

