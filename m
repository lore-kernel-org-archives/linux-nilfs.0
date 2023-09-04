From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 10/11] vfs: trylock inode->i_rwsem in iterate_dir() to
 support nowait
Date: Mon, 4 Sep 2023 11:37:35 +0200
Message-ID: <20230904-qualm-molekular-84b4d1c79769@brauner>
References: <20230827132835.1373581-1-hao.xu@linux.dev>
 <20230827132835.1373581-11-hao.xu@linux.dev>
Mime-Version: 1.0
Return-path: <linux-unionfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693820264;
        bh=0Ik33Yv016rCo6eme+x5SGC/ICJgl1qh75BuncMETlY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MNfTeWYfzXJeH0UCFNOg/c0GoULakcQjn9VfWyUVERq4CF/GjwF0GqntM6SDP3JOZ
         HmWkjCX0fWCD0NTKEH60CwhxbThIKelKwPhRfwlUENM6XFv/l0IS1o7emDiU3H4sDY
         gBdwt4UfhIf4zsES+N5uNZjpkjwhbVWi5Ab2OqyRyLp8TjL/51+ZKLnqqjiaytC1AP
         9u5Hfrd311fN8uwk04vQvyQIEWGhHff8ReEnBJpxmNpAhf+mTtmR61x3ITKiyEvg8N
         IV2NFewIfJBwDwTjOygKdvYQVenO5HAiINSRfH2ApWi+qCWlvA9GPQvzS06JcPFvo3
         SRfjpmfcvOp9Q==
Content-Disposition: inline
In-Reply-To: <20230827132835.1373581-11-hao.xu@linux.dev>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Xu <hao.xu@linux.dev>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Dominique Martinet <asmadeus@codewreck.org>, Pavel Begunkov <asml.silence@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>, Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-cachefs@redhat.com, ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, codalist@coda.cs.cmu.edu, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-m

On Sun, Aug 27, 2023 at 09:28:34PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Trylock inode->i_rwsem in iterate_dir() to support nowait semantics and
> error out -EAGAIN when there is contention.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---

Unreviewable until you rebased on -rc1 as far as I'm concerned because
the code in here changed a lot.
