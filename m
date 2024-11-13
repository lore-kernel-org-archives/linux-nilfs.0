Received: from out203-205-221-173.mail.qq.com (out203-205-221-173.mail.qq.com [203.205.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF0241C64;
	Wed, 13 Nov 2024 02:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731465223; cv=none; b=nqCGVve4hZot12aRO4W/nZGodQuvsgvwqT27RmaC+gs71Ll090S2Mn5EUJzAqi1OkKlXhwnVjym1cIJ0OJt3d9tEDHCsUyjlAfal0Rk2VeQ/a65gKSgEKd4nEAmjmblQwWeqMP+iRtD4KilyErJ7n2hxswqqHmLztrj0ZRAWfuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731465223; c=relaxed/simple;
	bh=T4XiY+bK42Ehq/aZIWhwBuyAaO3UQFFaefnl3typawE=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pj6YwcxP/5Gmcy6a9iVvgoEmF9H1GnBK1BFDiuFqhHrwhG5PoZIhTSXog+Y8bhYMbmlBAev9qAUBzTbW23hxCG9hwg6TlZmYCnsNniOL87tsHga7cRU6fZiQUtHn17HhAS0w2hW8uHH92Kl8C8pSxymfW85A3N3wsxvg4Yz+kbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=rqi09lYK; arc=none smtp.client-ip=203.205.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="rqi09lYK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1731464910; bh=H/LbfWgCXVb/MUnrh8iWjUzx8J6cNgdw3TOHUf3BUkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rqi09lYKL8yT7xwF54KUMQThpmmC3Vp+2t7e1yKSpahj8N3XDZ7KMiVwH0KdTx23F
	 JtaQ5q9FSfUNFSpNeLcls2kdMcsFZj9nEZ9Wmz+2Ulm/v9M1BJpE4M4Q9bT+SAKE+V
	 xCxGsLN+WhTFhJQMRCDzCCqw7eANyBHsffw8zXYU=
Received: from pek-lxu-l1.wrs.com ([111.198.227.254])
	by newxmesmtplogicsvrsza29-0.qq.com (NewEsmtp) with SMTP
	id 71CA005B; Wed, 13 Nov 2024 10:28:28 +0800
X-QQ-mid: xmsmtpt1731464908tuscwode7
Message-ID: <tencent_5ED37D036BA97D43A6A4549765F77C86CE05@qq.com>
X-QQ-XMAILINFO: Mm/8i8/T4yneFFz4uTKgblfj1af0W58+hR271CMjv5TNyODLOsMxWD7fmBw4pg
	 FBnv1a4mXl8UVU6fO9qO04FbDW4DHMms6y9yCrzZt5QYImlgvUoQQInDqssac8c6gNItH394pNWc
	 +gi0p3juFx9QAXAI1R6akk3HzhVy5VpadmnfzFxzqHxNYlYWN9gFcWefeXKb1P6OubMwcQdE+TmH
	 fdJmqy1j3tk5FVTDl9L5/e+IF7/V8h1boFx8S2r5E5roVRXaKJK7exvAoXPYig31DYndGBNxaQtv
	 JWcR9WcK9ICCxdQG38d3dWPIojj+2uhlCJqKv9u97vClQB41ptXxv382Ktp49yVhX0lu2uHnhuXY
	 lYtZUA5yGXMK3iaoAjokNX6ZM4Fzu20XbH7GdrJu0vKQ8ut0Vt4fA2/HWnvKMlaNOQg0ZkIjWrvo
	 lHhJgMl+D8pqfSaRLFEmudgaZUCQekmvRh8EFxS0w+qYxcIBRF5NZ1zrr1tBTNTG2ucfIHY6ogP4
	 6Ms1IRYruVB1t0dNpLYmqEmvMKm0IB/i/0RKMxBAnCf6cL372wobMjFitABPQtLIEiKoziut0fKD
	 I6yu0donYBbSrgpfjVvk26u2Y6FXgUNby56nzcaHufJZ7coSXscznd10mILJghmZG12i8NvnCq0I
	 RONSpidPdkVr1JKDzZmjWmD/MLymkhbS06aIGhkABALOBX3DUNb8+2nhepShgQqr98nozbXhLlOs
	 CnzEWZ3AgWe/qpa1Bd7eU/AfqpVJqR8k13lQkHBobcsKnb3qp7mnlwUAM7Fs5zCvXaIuwenYBhNl
	 B4cWOzSPhDYgHLaIne9iOzUR7q66NU9ewdslCLEdlrTd5ZhC4sbjMQzfjLRipYXVmpo3BA1dFvda
	 tR0jejzgHId61HNLMv6v1x0hiWYaFseB14t0t5lNlGEpRyx8p8okmLhkosYUHGm/PDdjcFZpovha
	 qs7kLdL64=
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
From: Edward Adam Davis <eadavis@qq.com>
To: konishi.ryusuke@gmail.com
Cc: eadavis@qq.com,
	linux-kernel@vger.kernel.org,
	linux-nilfs@vger.kernel.org,
	syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] nilfs2: fix a uaf in nilfs_find_entry
Date: Wed, 13 Nov 2024 10:28:28 +0800
X-OQ-MSGID: <20241113022828.1824415-2-eadavis@qq.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <CAKFNMomm9UjJxdxADBDTL4ksvY7Bycs3WV=cqYmJu_TuUi7crA@mail.gmail.com>
References: <CAKFNMomm9UjJxdxADBDTL4ksvY7Bycs3WV=cqYmJu_TuUi7crA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Tue, 12 Nov 2024 23:38:11 +0900, Ryusuke Konishi wrote:
> On Tue, Nov 12, 2024 at 7:56 PM Edward Adam Davis wrote:
> >
> > The i_size value of the directory "cgroup.controllers" opened by openat is 0,
> > which causes 0 to be returned when calculating the last valid byte in
> > nilfs_last_byte(), which ultimately causes kaddr to move forward by reclen
> > (its value is 32 in this case), which ultimately triggers the uaf when
> > accessing de->rec_len in nilfs_find_entry().
> >
> > To avoid this issue, add a check for i_size in nilfs_lookup().
> >
> > Reported-by: syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=96d5d14c47d97015c624
> > Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> > ---
> >  fs/nilfs2/namei.c | 3 +++
> >  1 file changed, 3 insertions(+)
> 
> Hi Edward, thanks for the debugging help and patch suggestion.
> 
> But this fix is incorrect.
> 
> Reproducers are not creating the situation where i_size == 0.
> In my debug message output inserted in the while loop of
> nilfs_find_entry(), i_size was a corrupted large value like this:
> 
> NILFS (loop0): nilfs_find_entry: isize=422212465065984,
> npages=103079215104, n=0, last_byte=0, reclen=32
> 
> This is different from your debug result, because the type of i_size
> in the debug patch you sent to syzbot is "%u".
> The type of inode->i_size is "loff_t", which is "long long".
> Therefore, the output format specification for i_size in the debug
> output should be "%lld".
Yes, you are right, I ignore the type of i_size.
> 
> If you look at the beginning of nilfs_find_entry(), you can see that
> your check is double-checked:
> 
> struct nilfs_dir_entry *nilfs_find_entry(struct inode *dir,
>                 const struct qstr *qstr, struct folio **foliop)
> {
>         ...
>         unsigned long npages = dir_pages(dir);
Yes, now I noticed dir_pages().
>         ..
> 
>         if (npages == 0)
>                 goto out;
>         ...
> 
> Here, dir_pages() returns 0 if i_size is 0, so it jumps to "out" and
> returns ERR_PTR(-ENOENT).
> 
> I'm still debugging, but one problem is that the implementation of
> nilfs_last_byte() is incorrect.
> In the following part, the local variable "last_byte" is not of type
> "loff_t", so depending on the value, it may be truncated and return a
> wrong value (0 in this case):
> 
> static unsigned int nilfs_last_byte(struct inode *inode, unsigned long page_nr)
> {
>         unsigned int last_byte = inode->i_size;
>         ...
> }
> 
> If this is the only problem, the following fix will be effective. (To
> complete this fix, I think we need to think more carefully about
> whether it's okay for i_size to have any value, especially since
> loff_t is a signed type):
> 
> diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> index a8602729586a..6bc8f474a3e5 100644
> --- a/fs/nilfs2/dir.c
> +++ b/fs/nilfs2/dir.c
> @@ -70,7 +70,7 @@ static inline unsigned int nilfs_chunk_size(struct
> inode *inode)
>   */
>  static unsigned int nilfs_last_byte(struct inode *inode, unsigned long page_nr)
>  {
> -       unsigned int last_byte = inode->i_size;
> +       loff_t last_byte = inode->i_size;
> 
>         last_byte -= page_nr << PAGE_SHIFT;
>         if (last_byte > PAGE_SIZE)
> 
I have noticed nilfs_last_byte(), I have other concerns about it, such
as the chance of last_byte overflowing when i_size is too small and page_nr
is too large, or that it will be negative after being type-adjusted to loff_t.
So, maybe following fix is more rigorous.

diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index a8602729586a..0dbcf91538fd 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -70,9 +70,10 @@ static inline unsigned int nilfs_chunk_size(struct inode *inode)
  */
 static unsigned int nilfs_last_byte(struct inode *inode, unsigned long page_nr)
 {
-       unsigned int last_byte = inode->i_size;
+       loff_t last_byte = inode->i_size;

-       last_byte -= page_nr << PAGE_SHIFT;
+       if (last_byte > page_nr << PAGE_SHIFT)
+               last_byte -= page_nr << PAGE_SHIFT;
        if (last_byte > PAGE_SIZE)
                last_byte = PAGE_SIZE;
        return last_byte;
BR,
Edward
> 
> Regards,
> Ryusuke Konishi
> 
> 
> >
> > diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
> > index 9b108052d9f7..0b57bcd9c2c5 100644
> > --- a/fs/nilfs2/namei.c
> > +++ b/fs/nilfs2/namei.c
> > @@ -60,6 +60,9 @@ nilfs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
> >         if (dentry->d_name.len > NILFS_NAME_LEN)
> >                 return ERR_PTR(-ENAMETOOLONG);
> >
> > +       if (!dir->i_size)
> > +               return ERR_PTR(-EINVAL);
> > +
> >         res = nilfs_inode_by_name(dir, &dentry->d_name, &ino);
> >         if (res) {
> >                 if (res != -ENOENT)
> > --
> > 2.43.0
> >

