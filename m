Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DC61FCC50;
	Tue, 12 Nov 2024 14:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731422312; cv=none; b=WtT3fZTDiynt72Te7FRtA9PIIvxci5f77+XGnsxr5sU8+3qtzojAuZZnVK/K59hRoCQpvxmB6sKcyiH+hkXGfjgl/yJrc300HZqW1vhaLLHLqrxbValGoYP+jGgTeLsifBqd1pwKy4e6EMhMOY7Y9fp+Z6eZ8Bfe+1x+EpBRBoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731422312; c=relaxed/simple;
	bh=OkmAd4UeuSfSOashRPZrV/Z61nQ6lZgaDcTwq+CNgxc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sXVxb+tpXI8XAPA7dblF5Dfir1W5fNyjiehTfgx6r1VLJMbA0dpqe79XS4myrvXKJocCsDG4mcGuc4J/cimKB3dpulP3AEPg3PJ1b7nYr7YRNn5wNY1TAtpWXP1QkBtlGcopfb63uzwhAVXEMtDNmj6spt3uw1Lvj7XrxrZjBts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OsnvNnnB; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OsnvNnnB"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-539e63c8678so6690612e87.0;
        Tue, 12 Nov 2024 06:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731422308; x=1732027108; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WAUgDVn1O2daxWXQiHB//Wl8FmWmQRwezlSUd1CZ4rs=;
        b=OsnvNnnBVVIH760K7MCO2U7a3p+TQEydjeUV2NLA16AT5OoSU5HBGwQo+v8jbnA9nF
         GfKXhMMyD4GjXQOP0UH8fxF3RrtIMjHE3vk7/u9UxvQZy+tAZUdRRk+3fw99Drrq3yYd
         4Tm5O2ePTdH4dJoGN8jhACW8s2RQB91k4LFQnRsnYMi+6Jo02puJz4G3eVKD3URYBB/k
         6q/y47ZE5Bls83AC4+8HVgO7nB+Cwq+oHT6W+MbtizF4n34R1jWkQCKWexJlNaBjWpSS
         W1G+5f8j1S3CMkZt+H0WegXyeoDIGNbY+YM9Svayq59YPJy5Rf7QmxkLK4blC0aOZgmi
         RNww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731422308; x=1732027108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WAUgDVn1O2daxWXQiHB//Wl8FmWmQRwezlSUd1CZ4rs=;
        b=oOIYreQVkdtaAhn3r0LrUHX6eeC6lTsKncDc2ec5ZyvyWp/dFRoYL3fYYreM5MLgSh
         RVA/08bih/5C8JiX/wnk9VXJg9BJAznqSGXSLSFswecG7QfZddtRImM60hGwcQdidv1j
         +GEa075zjgfJv9NEB7Cs1e3DW7FP7ewct0CWgFCweeQx6Jj4EqWE1ftbDE1W/Ihdeway
         h/mQzCje16zgveGIKVUv/6Mh/aNgpoME5fRxXOBl/gszJ6XzRbMJQId6KPPHbgt8/xlY
         fadLMQVQ/R8OUqRnHuXjzi9dsQki2Fg5lEqU9qPPMBJjgZ0yJCjNLO3bh5L3oTeTzLj8
         6qiw==
X-Forwarded-Encrypted: i=1; AJvYcCX/2vtLPr/kgJQkkP9R1DCMpOHk4pdE7/knrId7asM1UUBliIM7ugSAn3VAsen3HEjsaG3IvqTcbAMK3AE=@vger.kernel.org, AJvYcCXvD/2f6IV2ALrdtQZw9bFc7karNdm4CqQcvJrKR3ZeR2qfLwwrUL05CWLVzjaiwOAFlkjB7zpg8S7+NGY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp6zW5BeKs7EI0hYpBtNS/ceEiQVVFXBxJEaMrc+lT06/BmQee
	X5yUWNBIgcmr0FS8nTvQm21RGiBJAgcFKjcIV05dRAaU+h8RQY8gjx2l6srr84OilmffO4HJlLS
	kHtMlrnkGzzfIXva1X0UXPky+wvc=
X-Google-Smtp-Source: AGHT+IGFXApqz8ubIfdp04DuiA0aOT3JxlUgIDBb4dM8KgqQXt+4krUKZThhF+uX3OmUwU/PwtFM/649RXnsB6dI/j8=
X-Received: by 2002:a05:6512:3ca2:b0:539:968a:91a8 with SMTP id
 2adb3069b0e04-53d86302ec3mr7811962e87.47.1731422307825; Tue, 12 Nov 2024
 06:38:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6732e1d8.050a0220.138bd5.00d3.GAE@google.com> <tencent_4A46BB45335A9E721B634B011B242548BA08@qq.com>
In-Reply-To: <tencent_4A46BB45335A9E721B634B011B242548BA08@qq.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Tue, 12 Nov 2024 23:38:11 +0900
Message-ID: <CAKFNMomm9UjJxdxADBDTL4ksvY7Bycs3WV=cqYmJu_TuUi7crA@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: fix a uaf in nilfs_find_entry
To: Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com, 
	linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2024 at 7:56=E2=80=AFPM Edward Adam Davis wrote:
>
> The i_size value of the directory "cgroup.controllers" opened by openat i=
s 0,
> which causes 0 to be returned when calculating the last valid byte in
> nilfs_last_byte(), which ultimately causes kaddr to move forward by recle=
n
> (its value is 32 in this case), which ultimately triggers the uaf when
> accessing de->rec_len in nilfs_find_entry().
>
> To avoid this issue, add a check for i_size in nilfs_lookup().
>
> Reported-by: syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D96d5d14c47d97015c624
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
>  fs/nilfs2/namei.c | 3 +++
>  1 file changed, 3 insertions(+)

Hi Edward, thanks for the debugging help and patch suggestion.

But this fix is incorrect.

Reproducers are not creating the situation where i_size =3D=3D 0.
In my debug message output inserted in the while loop of
nilfs_find_entry(), i_size was a corrupted large value like this:

NILFS (loop0): nilfs_find_entry: isize=3D422212465065984,
npages=3D103079215104, n=3D0, last_byte=3D0, reclen=3D32

This is different from your debug result, because the type of i_size
in the debug patch you sent to syzbot is "%u".
The type of inode->i_size is "loff_t", which is "long long".
Therefore, the output format specification for i_size in the debug
output should be "%lld".

If you look at the beginning of nilfs_find_entry(), you can see that
your check is double-checked:

struct nilfs_dir_entry *nilfs_find_entry(struct inode *dir,
                const struct qstr *qstr, struct folio **foliop)
{
        ...
        unsigned long npages =3D dir_pages(dir);
        ..

        if (npages =3D=3D 0)
                goto out;
        ...

Here, dir_pages() returns 0 if i_size is 0, so it jumps to "out" and
returns ERR_PTR(-ENOENT).

I'm still debugging, but one problem is that the implementation of
nilfs_last_byte() is incorrect.
In the following part, the local variable "last_byte" is not of type
"loff_t", so depending on the value, it may be truncated and return a
wrong value (0 in this case):

static unsigned int nilfs_last_byte(struct inode *inode, unsigned long page=
_nr)
{
        unsigned int last_byte =3D inode->i_size;
        ...
}

If this is the only problem, the following fix will be effective. (To
complete this fix, I think we need to think more carefully about
whether it's okay for i_size to have any value, especially since
loff_t is a signed type):

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index a8602729586a..6bc8f474a3e5 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -70,7 +70,7 @@ static inline unsigned int nilfs_chunk_size(struct
inode *inode)
  */
 static unsigned int nilfs_last_byte(struct inode *inode, unsigned long pag=
e_nr)
 {
-       unsigned int last_byte =3D inode->i_size;
+       loff_t last_byte =3D inode->i_size;

        last_byte -=3D page_nr << PAGE_SHIFT;
        if (last_byte > PAGE_SIZE)


Regards,
Ryusuke Konishi


>
> diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
> index 9b108052d9f7..0b57bcd9c2c5 100644
> --- a/fs/nilfs2/namei.c
> +++ b/fs/nilfs2/namei.c
> @@ -60,6 +60,9 @@ nilfs_lookup(struct inode *dir, struct dentry *dentry, =
unsigned int flags)
>         if (dentry->d_name.len > NILFS_NAME_LEN)
>                 return ERR_PTR(-ENAMETOOLONG);
>
> +       if (!dir->i_size)
> +               return ERR_PTR(-EINVAL);
> +
>         res =3D nilfs_inode_by_name(dir, &dentry->d_name, &ino);
>         if (res) {
>                 if (res !=3D -ENOENT)
> --
> 2.43.0
>
