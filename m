From: Ross Zwisler <zwisler@gmail.com>
Subject: Re: [PATCH v9 07/61] xarray: Add the xa_lock to the radix_tree_root
Date: Thu, 12 Apr 2018 15:27:32 -0600
Message-ID: <CAOxpaSWbgoNYOW81ves7Ry+Qyu1-WDPci4dLy1b2p+LjEDwQnA@mail.gmail.com>
References: <20180313132639.17387-1-willy@infradead.org> <20180313132639.17387-8-willy@infradead.org>
 <CAOxpaSXDX1fyrOnnsehEoRgQz2_K1OmOn9TikZzJcXmwMLEfnA@mail.gmail.com>
 <20180412211036.GB18364@bombadil.infradead.org> <CAOxpaSV5L_O9zO_+JLXk9e3SMjm0Gc90ZxSEHaJmvN5YsYpjMA@mail.gmail.com>
 <20180412212203.GD18364@bombadil.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9Y1llrgSfh7x2wFH1APr3MQVdkrBGtW/XXpbVPYzgZk=;
        b=NNKZFGiK4NTwh9yKvhW7r/8hRZELNiTtXKw1gqN3KTB7tAuD2/djtyF8qWKhjQwEhp
         ebtqZM+ppWZntkm8KyNEF2hpsJj8JdIkAf/GClA6JTwcL/bvlYoas2jfQkBZ7ilI5SYL
         MP6BlvuMq5byVhIjg4DY10vPlZMcm/ltLRz9tN0Klfu7jtFwmhYJA1TrndacDlFHZNGi
         9IlMTVcO67CNMfu6XkLtki7kK/zFFexZLFOw7PX7VMz1fpXsvAF2zwWpkBw9sqWmRDEW
         ZInuOkIv7oT7N3MhBnGi6Kruu7ivLt6EU+4+2j2Ge1TWVAE5QTeEKbqy8C0kNeg3yYtY
         /UGA==
In-Reply-To: <20180412212203.GD18364@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

On Thu, Apr 12, 2018 at 3:22 PM, Matthew Wilcox <willy@infradead.org> wrote=
:
> On Thu, Apr 12, 2018 at 03:16:23PM -0600, Ross Zwisler wrote:
>> On Thu, Apr 12, 2018 at 3:10 PM, Matthew Wilcox <willy@infradead.org> wr=
ote:
>> > On Thu, Apr 12, 2018 at 02:59:32PM -0600, Ross Zwisler wrote:
>> >> This is causing build breakage in the radix tree test suite in the
>> >> current linux/master:
>> >>
>> >> ./linux/../../../../include/linux/idr.h: In function =E2=80=98idr_ini=
t_base=E2=80=99:
>> >> ./linux/../../../../include/linux/radix-tree.h:129:2: warning:
>> >> implicit declaration of function =E2=80=98spin_lock_init=E2=80=99; di=
d you mean
>> >> =E2=80=98spinlock_t=E2=80=99? [-Wimplicit-function-declaration]
>> >
>> > Argh.  That was added two patches later in
>> > "xarray: Add definition of struct xarray":
>> >
>> > diff --git a/tools/include/linux/spinlock.h b/tools/include/linux/spin=
lock.h
>> > index b21b586b9854..4ec4d2cbe27a 100644
>> > --- a/tools/include/linux/spinlock.h
>> > +++ b/tools/include/linux/spinlock.h
>> > @@ -6,8 +6,9 @@
>> >  #include <stdbool.h>
>> >
>> >  #define spinlock_t             pthread_mutex_t
>> > -#define DEFINE_SPINLOCK(x)     pthread_mutex_t x =3D PTHREAD_MUTEX_IN=
ITIALIZER;
>> > +#define DEFINE_SPINLOCK(x)     pthread_mutex_t x =3D PTHREAD_MUTEX_IN=
ITIALIZER
>> >  #define __SPIN_LOCK_UNLOCKED(x)        (pthread_mutex_t)PTHREAD_MUTEX=
_INITIALIZER
>> > +#define spin_lock_init(x)      pthread_mutex_init(x, NULL)
>> >
>> >  #define spin_lock_irqsave(x, f)                (void)f, pthread_mutex=
_lock(x)
>> >  #define spin_unlock_irqrestore(x, f)   (void)f, pthread_mutex_unlock(=
x)
>> >
>> > I didn't pick up that it was needed this early on in the patch series.
>>
>> Hmmm..I don't know if it's a patch ordering issue, because this
>> happens with the current linux/master where presumably all the patches
>> are present?
>
> No, Andrew only merged the first 8 or so because of lack of review of
> the remaining patches.  Even though I cc'd people as hard as I could.
> Including you.  :-P
>
> You could, for example, review the DAX patches ...

Fair enough.  Let's get the radix tree working, and in the mean time
I'll throw it into my xfstests testing setup & take a look at the DAX
patches.
