Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997A32185BD;
	Thu,  9 Jan 2025 13:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736430293; cv=none; b=P47Z8bu9EgXoRzft+aEqxboQZ1NvgJ+4gsJg6EAih+Pne5HviIFrlHHIChz013Tb7ECRR84zfw4IU7HRbpnVbXCCdcKLbhWhyQeDN91GC5EA1QswZ+PxgeAkm0QBW1X7Acoon9rKUW/9rogh4EAW7dBvH5tYqnAXI4spQJRlYVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736430293; c=relaxed/simple;
	bh=OA/xACkz7k3dXWDmzuqIPD6V6Vm2v5uhyBmwRqmRLKE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hsVLRI7EOOOLRnfpOOhc9P58ZI/OXq6GB+XHLnnnzZcZ7bPTL43pRCOA+fKLY7V0Oz7ZpQ7y7+MZFfwXtmu26lvV7XE3hWPsIOka0HsQqHZNcImgVxhSGna8A7S4GE8f+lz1tiZSyPDGZjY/ATVp/iftWOylUOUuxIdFNYiIOfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kuUrfVAc; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kuUrfVAc"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5d932eac638so1622204a12.1;
        Thu, 09 Jan 2025 05:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736430290; x=1737035090; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bNZEIyk0i99KxmuI9nJgiFkuIgb8dFWxQQIWGEC6gNA=;
        b=kuUrfVAcQHFx48xL+nKlJNU+heMHItlM6mPAp2m+8nqH0+V+TXNPQB9NKbWmiHlBmD
         nskaEIGqbSO/nrg9PeElQ9ngb2ZQQV+wtQKqAo/NuNxDD7G9K6J569jkKTTB3cpY5lzE
         6gK01m2DIgn8K96YwU4YCWPBrC659AfHs8xmuvjSCdnjo+ymWd6EPBokJU4Yrm0rbVuA
         IpxvMDoBxfhCL8wloMpKJ8AjH5goJ48Hdf+PaZvFC0nBi3PW2T54PzYsyPlrL0A1AskU
         NYdExV7Kzh7Hpga/mMpW47HBRal0Hfhsn5A180qwKwOftz6I+zAw8V5vrJsiyBs3j82O
         c1Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736430290; x=1737035090;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bNZEIyk0i99KxmuI9nJgiFkuIgb8dFWxQQIWGEC6gNA=;
        b=PydCtW/V4+2I+PpPSetEj5EclNSyFcvWpZrkSAR1wTmpyaBh9G7XI+i8ANTQFVfIEO
         UQdf65ndSYSEbjsvdrbTndnQmsTksXVVnv66mPAY6JZapsCLko3Ox4Hhs/9gTrgmPcw8
         SiY+OYbol8k6e0XrZL39n8Ln8KSbB7+62cLGuNIy3HriwsrqHXXoxTMf8K4aFdKjLPQm
         guamQNmKZM9TD449XMVLNYdkJ4cOadYJqmi9YGnKdCHAPXFXKZNrjMg+q+VIuivlU+g1
         v6rExQr9P4KE7UlJ23tRg552jo/MhWWeyqH22Tp2CFuWfzA+35EPvvO4FLW8eCtEiuFS
         NWMw==
X-Forwarded-Encrypted: i=1; AJvYcCVBlbtAsN5p3q6oif7FAhJoUUqAzSSy4GiKOfd4g0D8ahc8oOlVCtqiXbZLFfG4juHApOqrUgmIgYzP7JY=@vger.kernel.org, AJvYcCWFLe1NrdBOyjfORrC2qASgyYfxObdpPvdgxoGgtho70eREi1ZoJGvtCneqizBmMudW8bd0LZtWiANkaNc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJqaaE3owYrYmLLZIs3cHnNSo3Drrf5ORo3+4IW6vJH4GgDbZ4
	82rJhYTJhNP2F/LI2OaNEMztszpTobPUJRNOqhnbCPk2w5DfKh7KWTVrCWfwKCW0zOO2mGIgfq6
	K9xv4FWXxoc5b+xDr270byatz2/k=
X-Gm-Gg: ASbGnctJEE1+ql6nvuz0U/dzekjCD6mERbmZ/hk/K7QHGPkNLzwEVG6w4fFnzEmDA8Y
	wnAesphHh6UNqgFxNV6u4/3MV8CgUOoKh3WOkPQ==
X-Google-Smtp-Source: AGHT+IHbP3Bj8Od3MJGCuzJa4r6z4r5P+pgfWJ+GcqOV7Jemv1zFwGCuXB4OlkgLM057fz6qZEoopSuKAUJSUF7cHo8=
X-Received: by 2002:a17:907:d87:b0:aa6:9599:a9af with SMTP id
 a640c23a62f3a-ab2abdbfe04mr706896866b.53.1736430289683; Thu, 09 Jan 2025
 05:44:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109032846.10147-1-konishi.ryusuke@gmail.com> <20250109032846.10147-2-konishi.ryusuke@gmail.com>
In-Reply-To: <20250109032846.10147-2-konishi.ryusuke@gmail.com>
From: "Brian G." <gissf1@gmail.com>
Date: Thu, 9 Jan 2025 07:44:38 -0600
X-Gm-Features: AbW1kvbyOgFTUYa3e42IAUr4lc6Xt6KdRqQ44lwEhQbgEgoB0U7EeurRhWsGlVM
Message-ID: <CAAq45aNh1qV8P6XgDhKeNstT=PvcPUaCXsAF-f9rvmzznsZL5A@mail.gmail.com>
Subject: Re: [PATCH 1/6] nilfs2: correct return value kernel-doc descriptions
 for ioctl functions
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nilfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Ryusuke,

I'm somewhat new to public linux kernel contributions, but I have been
following the NILFS2 mailing list for a while now.  I know you have
been putting in incredible effort into supporting NILFS2, and I
appreciate the time and dedication you have provided to the community
on this.

I think the new description comments look much cleaner and easier to
read, but while reviewing your changeset, I noticed a few small
concerns.  I will describe them inline below.

On Wed, Jan 8, 2025 at 9:28=E2=80=AFPM Ryusuke Konishi
<konishi.ryusuke@gmail.com> wrote:
> ---
>  fs/nilfs2/ioctl.c | 220 ++++++++++++++++++----------------------------
>  1 file changed, 84 insertions(+), 136 deletions(-)
>
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index fa77f78df681..f7bcc95847bb 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -457,7 +439,8 @@ nilfs_ioctl_do_get_vinfo(struct the_nilfs *nilfs, __u=
64 *posp, int flags,
> - * Return value: count of nilfs_bdescs structures in output buffer.
> + * Return: Count of nilfs_bdescs structures in output buffer on succes, =
or
Typo: "succes" should be "success"

> @@ -494,19 +477,14 @@ nilfs_ioctl_do_get_bdescs(struct the_nilfs *nilfs, =
__u64 *posp, int flags,
> - * %-EFAULT - Failure during getting disk block descriptors.
> + * * %-EFAULT  - Failure during getting dick block descriptors.
Typo: "dick" should be "disk"

> @@ -1202,18 +1156,12 @@ static int nilfs_ioctl_get_info(struct inode *ino=
de, struct file *filp,
> - * %-ENOMEM - Insufficient amount of memory available.
The error value -ENOMEM can still be returned by the new code, but it
is not included in the new error list

Also, throughout the changeset, in multiple files, I saw lines like:
> + * Return: 0 on success, or the following error code on failure.

These lines should probably instead be something like:
> + * Return: 0 on success, or one of the following negative error codes on=
 failure:
Noting the specific differences of:
- "one of" prefix before "the following" when there are more than 1
option in the list
- be sure to include the word "negative" (some cases did, others did not)
- using the plural form "codes" instead of singular "code" when there
are more than 1 option in the list
- trailing ":" to indicate that a list follows

I hope this email was helpful, and thanks again for all you do!

- Brian G.
