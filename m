From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [syzbot] [nilfs?] kernel BUG in folio_end_writeback
Date: Tue, 22 Aug 2023 01:47:38 +0900
Message-ID: <CAKFNMo=XRe5UZeOEumfTJYRndDb0YrxhO=9261jq4aRNaPqXYg@mail.gmail.com>
References: <000000000000dc83d605f0c70a11@google.com> <000000000000d299b406035f1bbd@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692636474; x=1693241274;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hjQRVQRH0MvBIBCqexCP9I4hxh2GB6Sga648A3l5Ff4=;
        b=Trc+Nuk70hE9cFyGdyaBBS4Hvt2YDyB60rzHz7DgQQFP5q9OEqhFIYNGJSaJ5srF1f
         9o2mxJJPBRG7/O5t/1hejqthljOjJAimAKmmabgQiEiBF5/d9AWiKizhLFSk1hUkLetP
         H4wQPKCeUVWddoizlXW/sjf1IzpUvEHgDRYrrN97XyjBkWzohkvw6VvoEarrc3AZ0/zo
         fDaiqvvW/ILiucOmBxVOQhnenIDs5NwPAWatx6z+YqrcnAEUCPL31bOZmr8A6XuB+62q
         976VsBd4opwBtNKfGUudUczDC2J3tg5uCG2EFGWCyTone6v6xrNxigoTuU8k5QD3fTP2
         zeIw==
In-Reply-To: <000000000000d299b406035f1bbd@google.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: syzbot <syzbot+7e5cf1d80677ec185e63@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk, willy@infradead.org

On Mon, Aug 21, 2023 at 3:41=E2=80=AFAM syzbot
<syzbot+7e5cf1d80677ec185e63@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 92c5d1b860e9581d64baca76779576c0ab0d943d
> Author: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> Date:   Fri May 26 02:13:32 2023 +0000
>
>     nilfs2: reject devices with insufficient block count
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D170c6337a8=
0000
> start commit:   929ed21dfdb6 Merge tag '6.4-rc4-smb3-client-fixes' of git=
:..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D3da6c5d3e0a6c=
932
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D7e5cf1d80677ec1=
85e63
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D16cb3b69280=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D10f3420128000=
0
>
> If the result looks correct, please mark the issue as fixed by replying w=
ith:
>
> #syz fix: nilfs2: reject devices with insufficient block count
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion

I have confirmed that one of the five registered reproducers emits the
error message that is output when the above commit takes effect.
However, the remaining four did not.
So, I think it's premature to conclude that the issue has been fixed
by this commit at this time.

Ryusuke Konishi
