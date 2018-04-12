From: Ross Zwisler <zwisler@gmail.com>
Subject: Re: [PATCH v9 07/61] xarray: Add the xa_lock to the radix_tree_root
Date: Thu, 12 Apr 2018 14:59:32 -0600
Message-ID: <CAOxpaSXDX1fyrOnnsehEoRgQz2_K1OmOn9TikZzJcXmwMLEfnA@mail.gmail.com>
References: <20180313132639.17387-1-willy@infradead.org> <20180313132639.17387-8-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EMsk8lrTQSZfUeipbnCRp5jfEaYCHZDQTlL2aq2cX0k=;
        b=tgz0YVDSM8Lbm5IcJtrKeKYxnRNOb4x3qvQRW6X6ILS9XxFG2yCKKYvsjISdsAklcV
         pTH1rZJzci/mi0zjXbue4R1fYmZMyaMEM9twWNhdXPU6UIUBnRmuib58PLNnr0mVfETK
         X/yJ460TusAZ3xXMJycJx38dxBvzdZJjmROxaoG/xSLPohIuXGPrlW5z17NaE6ZhZhWj
         wCWZxnUIsr6AcrVyzapUk+7P10H6bBBRM5UliZBp4q+GyheTd6bP983YL+5I/eMQkeJD
         AtNZCBg1Iwc0dOhcZBropA7YkavhZW4mPCFpRxG6UHDpyEj3pKDNqWaPfKWIRvz6jdy4
         lsdQ==
In-Reply-To: <20180313132639.17387-8-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

On Tue, Mar 13, 2018 at 7:25 AM, Matthew Wilcox <willy@infradead.org> wrote=
:
> From: Matthew Wilcox <mawilcox@microsoft.com>
>
> This results in no change in structure size on 64-bit machines as it
> fits in the padding between the gfp_t and the void *.  32-bit machines
> will grow the structure from 8 to 12 bytes.  Almost all radix trees
> are protected with (at least) a spinlock, so as they are converted from
> radix trees to xarrays, the data structures will shrink again.
>
> Initialising the spinlock requires a name for the benefit of lockdep,
> so RADIX_TREE_INIT() now needs to know the name of the radix tree it's
> initialising, and so do IDR_INIT() and IDA_INIT().
>
> Also add the xa_lock() and xa_unlock() family of wrappers to make it
> easier to use the lock.  If we could rely on -fplan9-extensions in
> the compiler, we could avoid all of this syntactic sugar, but that
> wasn't added until gcc 4.6.
>
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>

This is causing build breakage in the radix tree test suite in the
current linux/master:

5d1365940a68 (linux/master) Merge
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net

Here's the first breakage:

cc -I. -I../../include -g -O2 -Wall -D_LGPL_SOURCE -fsanitize=3Daddress
 -c -o idr.o idr.c
In file included from ./linux/radix-tree.h:6:0,
                 from ./linux/../../../../include/linux/idr.h:15,
                 from ./linux/idr.h:1,
                 from idr.c:4:
./linux/../../../../include/linux/idr.h: In function =E2=80=98idr_init_base=
=E2=80=99:
./linux/../../../../include/linux/radix-tree.h:129:2: warning:
implicit declaration of function =E2=80=98spin_lock_init=E2=80=99; did you =
mean
=E2=80=98spinlock_t=E2=80=99? [-Wimplicit-function-declaration]
  spin_lock_init(&(root)->xa_lock);    \
  ^
./linux/../../../../include/linux/idr.h:126:2: note: in expansion of
macro =E2=80=98INIT_RADIX_TREE=E2=80=99
  INIT_RADIX_TREE(&idr->idr_rt, IDR_RT_MARKER);
  ^~~~~~~~~~~~~~~
