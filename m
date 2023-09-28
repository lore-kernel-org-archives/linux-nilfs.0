From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 87/87] fs: move i_blocks up a few places in struct inode
Date: Thu, 28 Sep 2023 14:35:13 +0300
Message-ID: <CAOQ4uxjSrgGr+6UOs4ADGYCderpQ7hAaPjNmB1DExAPLQQsHSg@mail.gmail.com>
References: <20230928110554.34758-1-jlayton@kernel.org> <20230928110554.34758-3-jlayton@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695900924; x=1696505724; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c3oHHfr+yAdtkrxVkV3qE0VFTbMzK/MU2TZf7sFiWp8=;
        b=LqyY8hs9A9caTY9HkGHjkatHTz13Eyh1e0RfVlzdYNHVcQ4xawfzRsb8SAF8+FiB55
         Ap4FsCtnlvlJl2J82fGi3G1CD7hAvh/XsAG90oflQxgPUewXcJL7CgKmYy9uIROUc4Dc
         Owrnxr9tl6aqLt0MPutbKd2IUZiLJPCOO15PEayhb2+CM/NB+2eCzdtqrNe/mgl3f9Ey
         22kUDmDYRKNx54JbwbI66PZVQD5YMK93hwM1SDVkK+PI4+D1P1ZxmQcwB5qxTkKhQtG2
         k0/ojp5/IJKLpS6Kabl0zX6Zt4hlo5TXU7FWxrYj3sk25whlDWt1POo7+hQgJdf8SLij
         Gu9w==
In-Reply-To: <20230928110554.34758-3-jlayton@kernel.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, David Sterba <dsterba@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Jeremy Kerr <jk@ozlabs.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>

On Thu, Sep 28, 2023 at 2:06=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> The recent change to use discrete integers instead of struct timespec64
> in struct inode shaved 8 bytes off of it, but it also moves the i_lock
> into the previous cacheline, away from the fields that it protects.
>
> Move i_blocks up above the i_lock, which moves the new 4 byte hole to
> just after the timestamps, without changing the size of the structure.
>

Instead of creating an implicit hole, can you please move i_generation
to fill the 4 bytes hole.

It makes sense in the same cache line with i_ino and I could
use the vacant 4 bytes hole above i_fsnotify_mask to expand the
mask to 64bit (the 32bit event mask space is running out).

Thanks,
Amir.

> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  include/linux/fs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index de902ff2938b..3e0fe0f52e7c 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -677,11 +677,11 @@ struct inode {
>         u32                     i_atime_nsec;
>         u32                     i_mtime_nsec;
>         u32                     i_ctime_nsec;
> +       blkcnt_t                i_blocks;
>         spinlock_t              i_lock; /* i_blocks, i_bytes, maybe i_siz=
e */
>         unsigned short          i_bytes;
>         u8                      i_blkbits;
>         u8                      i_write_hint;
> -       blkcnt_t                i_blocks;
>
>  #ifdef __NEED_I_SIZE_ORDERED
>         seqcount_t              i_size_seqcount;
> --
> 2.41.0
>
