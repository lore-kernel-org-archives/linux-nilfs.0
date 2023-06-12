From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [syzbot] [nilfs?] general protection fault in nilfs_clear_dirty_page
Date: Mon, 12 Jun 2023 12:59:39 +0900
Message-ID: <CAKFNMomCUnaB3_3chQm4P8devx2NwAp2hMpYfbyaHKyO2WLEkw@mail.gmail.com>
References: <000000000000da4f6b05eb9bf593@google.com> <000000000000c0951105fde12435@google.com>
 <20230612033023.GA16241@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686542396; x=1689134396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h5eFbd9HFD/KRz0+XmRiub04jDxZ5/25uC97kTShMpE=;
        b=EHyikn5gRvV78mN0YYf4xUPtAFpwRdYAhXIgBhQsen9zlXyZa6YQlQUu4I0VWvmJh+
         dhWeExCKRXcTldPlqkBujT4S8hYN9S3Jbd0cMP3UHAxhFpCvnWUtHmMlhjd82cWzsGvU
         Qb7ARehRdVdQqDwwsuvnhXh3B4toJX9+XvVg9hyMHUdMnCY5RWns/MKwcvTSzaHC+A5z
         LGWo7zNB0SZBqKipj0F/4Pdmq3YHlJiRJAryzsQ/uZsCXKixJBKSxVNWgBYySL2p8hyI
         XG2M96nT6JkeIkwNK/tgbq9u68or6XC76h7ZdsAV4l8TrLv8iVPvQyw7+G8nKpB+6EsB
         ZRJg==
In-Reply-To: <20230612033023.GA16241-jcswGhMUV9g@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: syzbot <syzbot+53369d11851d8f26735c-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, dsterba-IBi9RG/b67k@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, wqu-IBi9RG/b67k@public.gmane.org

On Mon, Jun 12, 2023 at 12:30=E2=80=AFPM Christoph Hellwig wrote:
>
> On Sun, Jun 11, 2023 at 02:18:29PM -0700, syzbot wrote:
> > syzbot has bisected this issue to:
> >
> > commit 4a445b7b6178d88956192c0202463063f52e8667
> > Author: Qu Wenruo <wqu-IBi9RG/b67k@public.gmane.org>
> > Date:   Sat Aug 13 08:06:53 2022 +0000
> >
> >     btrfs: don't merge pages into bio if their page offset is not conti=
guous
>
> I can't see how that btrfs commit would affect nilfs2..

Yeah, I think this bisection result is wrong.
I have already posted a bug-fix patch titled "nilfs2: prevent general
protection fault in nilfs_clear_dirty_page()"
for this issue.

Thanks,
Ryusuke Konishi
