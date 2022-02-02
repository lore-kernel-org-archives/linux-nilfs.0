From: Jens Axboe <axboe@kernel.dk>
Subject: Re: improve the bio allocation interface v2
Date: Wed, 02 Feb 2022 07:50:30 -0700
Message-ID: <164381343094.170143.694743005104706258.b4-ty__17581.1071925395$1643813456$gmane$org@kernel.dk>
References: <20220124091107.642561-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20220124091107.642561-1-hch@lst.de>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Philipp Reisner <philipp.reisner@linbit.com>, Pavel Begunkov <asml.silence@gmail.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, =?UTF-8?Q?_Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.co>, dm-devel@redhat.com, "Md . Haris Iqbal" <haris.iqbal@ionos.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org, Andrew Morton <akpm@linux-foundation.org>, ntfs3@lists.linux.dev, Jack Wang <jinpu.wang@ionos.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, drbd-dev@lists.linbit.com

On Mon, 24 Jan 2022 10:10:48 +0100, Christoph Hellwig wrote:
> this series is posted early because it has wide-ranging changes and could use some
> early ACKs before -rc1.
> 
> It changes the interface to the bio allocators to always pass a block_device and
> the operation, which is information needed for every bio submitted through
> bio_submit.  This means the fields can be directly initialized in bio_init instead
> of first being zeroed and thus should help to micro-optimize even better than the
> __bio_set_dev that Pavel proposed while also cleaning up code.
> 
> [...]

Applied, thanks!

[01/19] fs: remove mpage_alloc
        commit: d5f68a42da7a4516e7503c281a54a58727f07dc3
[02/19] nilfs2: remove nilfs_alloc_seg_bio
        commit: f0d911927b3c7cf5f9edb5941d0287144a602d0d
[03/19] nfs/blocklayout: remove bl_alloc_init_bio
        commit: 5d2ca2132f889bc2c90d6d07fc9fc129cfee8955
[04/19] ntfs3: remove ntfs_alloc_bio
        commit: 39146b6f66ba5c107d5c5758a17f290846165b4d
[05/19] dm: bio_alloc can't fail if it is allowed to sleep
        commit: 53db984e004c7116ce69e2f4a163664453336ae1
[06/19] dm-crypt: remove clone_init
        commit: 3f868c09ea8f40f800c4c644c072d91c9eee0d71
[07/19] dm-snap: use blkdev_issue_flush instead of open coding it
        commit: eba33b8ef1b90d8996eceb0569c06a4f784ef2b5
[08/19] dm-thin: use blkdev_issue_flush instead of open coding it
        commit: 28d7d128aad5cd2178b158900d58365d1fd3de94
[09/19] drbd: bio_alloc can't fail if it is allow to sleep
        commit: 4b1dc86d1857f1007865cab759f2285280692eee
[10/19] rnbd-srv: simplify bio mapping in process_rdma
        commit: 1fe0640ff94feae6d21417e2f4f2829b882274b1
[11/19] rnbd-srv: remove struct rnbd_dev_blk_io
        commit: d7b78de2b1552e3e7ce3a069f075cc2729aa5c34
[12/19] xen-blkback: bio_alloc can't fail if it is allow to sleep
        commit: 7d8d0c658d48705fca35238a8ff601b7c5cbc0de
[13/19] block: move blk_next_bio to bio.c
        commit: 3b005bf6acf009abd700e2c652c86e5c209cf63d
[14/19] block: pass a block_device and opf to blk_next_bio
        commit: 0a3140ea0fae377c9eaa031b7db1670ae422ed47
[15/19] block: pass a block_device and opf to bio_alloc_bioset
        commit: 609be1066731fea86436f5f91022f82e592ab456
[16/19] block: pass a block_device and opf to bio_alloc_kiocb
        commit: b77c88c2100ce6a5ec8126c13599b5a7f6663e32
[17/19] block: pass a block_device and opf to bio_alloc
        commit: 07888c665b405b1cd3577ddebfeb74f4717a84c4
[18/19] block: pass a block_device and opf to bio_init
        commit: 49add4966d79244013fce35f95c6833fae82b8b1
[19/19] block: pass a block_device and opf to bio_reset
        commit: a7c50c940477bae89fb2b4f51bd969a2d95d7512

Best regards,
-- 
Jens Axboe

