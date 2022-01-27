From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH 02/19] nilfs2: remove nilfs_alloc_seg_bio
Date: Fri, 28 Jan 2022 06:38:05 +0900
Message-ID: <CAKFNMomoLqbbOwg5d6aBHCyGT5v+NF=N2Rm3QwYk8NDXsoJHtA@mail.gmail.com>
References: <20220124091107.642561-1-hch@lst.de> <20220124091107.642561-3-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z+U+izVFukrEKq10kL5qCCsiT3qJmeLAo+mnNrOVCPU=;
        b=DwtRea8LCCOg/PGJHjd1bTltmn0bHa2clILkAwGYtZppoAY25qIBMTxyD6B5uMLit6
         7wk+d+sZiWX35l8wQaAoyrJ9H5CizW30SYci3NU1ojzD14qB67btK2MGpyfbQ3U8Fswu
         zxqpCDGkYCIAg/NDZ5r6/eIuacbMkuvBlqu9ammCZDYbuScyx0/VXZFI/czsoS4aCdCY
         RzPo3aqhubsJoGDCZLj5SmdkiGyLla36RWFVNiU5MVGZ7MrbcY5xEOS4+eUv/n2M8qYN
         MVuY5Y428ZMyJxOjYYJ1BtbtHPjLQ+HBbJ/bfmBPwl0UHF3vKl1N9F7XDbteSxFshMZ6
         OfIw==
In-Reply-To: <20220124091107.642561-3-hch@lst.de>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Mike Snitzer <snitzer@redhat.com>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Andrew Morton <akpm@linux-foundation.org>, "Md . Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.co>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-nilfs <linux-nilfs@vger.kernel.org>, ntfs3@lists.linux.dev, xen-devel@lists.xenproject.org, drbd-dev@lists.linbit.com

On Mon, Jan 24, 2022 at 6:11 PM Christoph Hellwig <hch@lst.de> wrote:
>
> bio_alloc will never fail when it can sleep.  Remove the now simple
> nilfs_alloc_seg_bio helper and open code it in the only caller.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/nilfs2/segbuf.c | 31 ++++---------------------------
>  1 file changed, 4 insertions(+), 27 deletions(-)

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks!

Ryusuke Konishi
