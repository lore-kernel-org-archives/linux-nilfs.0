From: Ross Zwisler <zwisler@gmail.com>
Subject: Re: [PATCH v9 07/61] xarray: Add the xa_lock to the radix_tree_root
Date: Thu, 12 Apr 2018 15:16:23 -0600
Message-ID: <CAOxpaSV5L_O9zO_+JLXk9e3SMjm0Gc90ZxSEHaJmvN5YsYpjMA@mail.gmail.com>
References: <20180313132639.17387-1-willy@infradead.org> <20180313132639.17387-8-willy@infradead.org>
 <CAOxpaSXDX1fyrOnnsehEoRgQz2_K1OmOn9TikZzJcXmwMLEfnA@mail.gmail.com> <20180412211036.GB18364@bombadil.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y5IIhKep3DmenKax6QAw6MNe/5Fbx2Oal8RU8NzFW+I=;
        b=niXxNLVa9aHQNPY7hELW3rFUgKA9iInCCcb2V+2M/HeaFhQZ58eFHVmHy1pZ6iaa27
         3gGJlCEIDrk6N0bAC9c5aBKCp0v3YsEY4uybQ4k7c5bRTc/nbEFyFK46J4FCRc1guJd/
         oGwCBggK4mnNu8YAwXwVZ46fUUV0+3KqcBnYnlaHFxCCWO3zqT1U8Ckjt2oc2gtECo3C
         krOPCbTkhUQBp9kLSFitklt/g3M73V/x7GVOfDDAlsbF6vHsv48vcVu26iYsj+hUJ7uf
         DLmXafIEYKO3JtTKTFMYGH+Oma7tzYhfONUwSJtjuTqtBghf45tkIMr3l0ShpbMtpm4J
         N0Yw==
In-Reply-To: <20180412211036.GB18364@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

On Thu, Apr 12, 2018 at 3:10 PM, Matthew Wilcox <willy@infradead.org> wrote=
:
> On Thu, Apr 12, 2018 at 02:59:32PM -0600, Ross Zwisler wrote:
>> This is causing build breakage in the radix tree test suite in the
>> current linux/master:
>>
>> ./linux/../../../../include/linux/idr.h: In function =E2=80=98idr_init_b=
ase=E2=80=99:
>> ./linux/../../../../include/linux/radix-tree.h:129:2: warning:
>> implicit declaration of function =E2=80=98spin_lock_init=E2=80=99; did y=
ou mean
>> =E2=80=98spinlock_t=E2=80=99? [-Wimplicit-function-declaration]
>
> Argh.  That was added two patches later in
> "xarray: Add definition of struct xarray":
>
> diff --git a/tools/include/linux/spinlock.h b/tools/include/linux/spinloc=
k.h
> index b21b586b9854..4ec4d2cbe27a 100644
> --- a/tools/include/linux/spinlock.h
> +++ b/tools/include/linux/spinlock.h
> @@ -6,8 +6,9 @@
>  #include <stdbool.h>
>
>  #define spinlock_t             pthread_mutex_t
> -#define DEFINE_SPINLOCK(x)     pthread_mutex_t x =3D PTHREAD_MUTEX_INITI=
ALIZER;
> +#define DEFINE_SPINLOCK(x)     pthread_mutex_t x =3D PTHREAD_MUTEX_INITI=
ALIZER
>  #define __SPIN_LOCK_UNLOCKED(x)        (pthread_mutex_t)PTHREAD_MUTEX_IN=
ITIALIZER
> +#define spin_lock_init(x)      pthread_mutex_init(x, NULL)
>
>  #define spin_lock_irqsave(x, f)                (void)f, pthread_mutex_lo=
ck(x)
>  #define spin_unlock_irqrestore(x, f)   (void)f, pthread_mutex_unlock(x)
>
> I didn't pick up that it was needed this early on in the patch series.

Hmmm..I don't know if it's a patch ordering issue, because this
happens with the current linux/master where presumably all the patches
are present?
