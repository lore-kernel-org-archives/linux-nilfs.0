Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0D543D4E9
	for <linux-nilfs@vger.kernel.org>; Mon,  7 Sep 2026 08:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788769592; cv=pass; b=IM7hWFo1CjlY98zLt8HsxaYlLwz4Lnxa07hhsZjD7R9bzuK7G9+OPXGvsPEuRDW2hSZVmLevztb3AH+fsknVLRI+6lUVw5SnpCm6MEQqv2EIl9K5Q0F+3XqVND5e+iCiSQIdSPBw18Rw9+CGB94hUeaWj4NpHCSqPi6UOZUHoz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788769592; c=relaxed/simple;
	bh=ipB2854ozcHKVg6XH2YQAsN4u0CkKe6GvPHBMmTx7DU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NKCxbPMscFBZWFpr0BHQ5GeY56vA36sBuCwAzlaolb5l7Nj0BSguO3c7ug03DewBlTMiq934luGqcuX/71sguSvJbsCsmsYp4069Rh/GmH//80chFEqwspOoepFriMuA9AgrPx9mT168yWC0PIs4mBsOfrJ/rrxWUxvkz8BztJc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e2xdKXpd; arc=pass smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e2xdKXpd"
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-66fb2fa79f2so1925302d50.0
        for <linux-nilfs@vger.kernel.org>; Mon, 07 Sep 2026 01:26:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788769588; cv=none;
        d=google.com; s=arc-20260327;
        b=eqF0dCEtmEVHTTkRNcf1kXxz5pcb38svBvOPdLk0J0rEGkzvllenBcfVYKr6sWO1L7
         bOk3GwSd8DMS/QaCN1GFlr7tY+0yQ2vHhD6Uir0WhVaqqfn5JUsQsYmlqKCXCaBgaeeD
         in1jBcDrfKhV6W8CSpCGUXRhj3isvHiFft4+sg3MYD8qxV6g2ArMlqwE6V1JAoevUJby
         88K81edu104HUmIZjs8c3spLKK9+2Pf2CS32DjgTFVVGkwChyANf6MS6zQuivdQ6Y9a7
         C6VoE/g9+/3E/+9DZQz2CWRs+3xJIQIBypNxB1ID5bJgC4ZLBW1o0NsR+EOPlJt7Jlo3
         BRBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j1TT4cxdSvOqJImR2JyQc+W0dHNOPWNC4ptEp9ACmzM=;
        fh=/Bz3PRjh6rbObzVcu2pXrzXt7UjeBh9oZADq3Roa98Y=;
        b=lmbh6R+8Cd6hvAhH9k6+5PndYp9kglqTsoR7d519z1il1p+AIKP7KgJUB3UB6HpbZH
         cSAirsSCDTN/jgF/D/ax44nrxPtx5rIjru6kdBhsb4EXxj2yVw4sYB7WHzM3/8u1IOBL
         HdafD+3pInmB94VC2X2AvVvPbT9JgTjijmTn4FqZwEYBkC71nmBTqTOtOW7FYHUvSP/Z
         W1/T7JqFKxJv+yHTHcN8uCRqmDzs5iZn4R4fsorHOt+VwUuTgUiyUxRo92Sg61SfRnaO
         hRoTBGUD1p5WvX6vAUsdswj4f3npiqHdcCp5usSRCuT8dhDIQNnjf1qU3fZIXXzutSV9
         F+3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788769588; x=1789374388; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=j1TT4cxdSvOqJImR2JyQc+W0dHNOPWNC4ptEp9ACmzM=;
        b=e2xdKXpd9hik78bTtsiqCa2H9U7AvFW+OBD3cltEM2r+W2ck9bJ21wmdA79QP+HBcN
         5OIM6WOIOk9vM2ODk4CwVVBeOW64bFuvEYDw2n1n9aqNIGsxRfGyb+zYom+d7vwSJfS6
         zw8ZpSTLF5uo6EP/2gsqMX3vuxKC/yfn0GOV/ANZgay2mpy7TJ8XLPQVTQWEEMS2RYxP
         mowTZjCNAxMgoCsL1iLqeLYL71PSejoxNFCie36/7XdH5w1xxCbK+7Kyh9hin5TrftLg
         9T+AU1EaWgooKY9uHWWpFwyT5LWRT7tqvSWtARpE2eEl0Tj7eAl4a5lDndYV5dsd6t1g
         NI6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788769588; x=1789374388;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j1TT4cxdSvOqJImR2JyQc+W0dHNOPWNC4ptEp9ACmzM=;
        b=CSaHogtdGe9wSFTS61YyZjx/W0OEHjGJEa8HC5+HKfJu0YWsIeB5CtZWkH5CqIDax4
         KDmhf4I8B47JrjNFT+4twWKY6TLBdr1dWqFU6HqkqQXli6eLtWI/W2AlnCuhDUaJo0Bv
         6g4vN6hHZRq23TBQRfIDrK/nlZsGsqcgaZZw0moWuEQeYjLYR3m0TZVre6AJJZxhqC07
         3lFOnBO1t/Yt5OsxxEc2380ZT72z5TAjecti16gGv6NSXtwbbJhMpoH2AzVxe+fhHLnH
         Q13nlh5+Vy58e5bKRKXYWsDauwmwPPRls0P63KMjjOb8cp7dJBvT2a64QXEnT0JXuGUe
         yFNA==
X-Gm-Message-State: AFuF++kVXAftkyoQd8FBG8BILEBQ4/7R6wUjDRMtR1Egy0i1/uDPJoXz
	6wInlMjfPYbnEIW/M1a+IF+qKPw/QkyMfjbFq6iOL2s6XktPn5+EVWDM9s6Ae7hXS7BG16egtCZ
	OaeVYWoeX3XcJhxFg+sqMChaYNmQULhU=
X-Gm-Gg: AYBFou03dVw7Q5r4Qa49UW9L8chByLbATtizVSCDF/SHXyNDrs9+mNtqLJn+bKX16u6
	Hey/is20SqiCjsV+USJqeWYNg+yf1dXpNs+oBvH4sjwiplEAyUU80yecHEK72gJOwld6eWDcOL/
	QfT+xC57kmmHzhWZG3JO7sSA4lezd9If7p85LEJfwGbpVjcdjEyeDjuyg5a1M4Xuqshhpw2kYpF
	gGHUCP8YJ759ckISlSQHNJ6G7oLPk1qWFIoduIDRv8uhudpZZIWCfPXWw65g+lsyEAIn7wjxFw9
	FDbBCx/aAIi0BcqbpKd5CoEnlywTf9W2Z0HD/PcpYJaN
X-Received: by 2002:a05:690e:1381:b0:66f:d093:c206 with SMTP id
 956f58d0204a3-66fd093c2bdmr1628991d50.17.1788769588341; Mon, 07 Sep 2026
 01:26:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260907062427.11910-1-hemanth.selam@gmail.com>
In-Reply-To: <20260907062427.11910-1-hemanth.selam@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Mon, 7 Sep 2026 17:26:10 +0900
X-Gm-Features: AcwNN1WG1Jj532-ZoTPWGvuaNMs2YmLY0fK-SGK5p_IrGQI1YE8Zkqlj9v1k3Mo
Message-ID: <CAKFNMok3MaD+fRcG6VbBRND3gZa+APt_jV63KtQzXzpX6vdCCw@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: fix typos in comments
To: Viacheslav Dubeyko <slava@dubeyko.com>, Hemanth Selam <hemanth.selam@gmail.com>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 7, 2026 at 3:24=E2=80=AFPM Hemanth Selam wrote:
>
> Fix typos in comments, reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.
>
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> ---

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Hemanth Selam, thank you for the patch.

Viacheslav, could you please add this to the queue for the next cycle as we=
ll?

Thanks,
Ryusuke Konishi

>  fs/nilfs2/sufile.c | 2 +-
>  fs/nilfs2/super.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
> index eceedca02697..6918be6fce2e 100644
> --- a/fs/nilfs2/sufile.c
> +++ b/fs/nilfs2/sufile.c
> @@ -1050,7 +1050,7 @@ ssize_t nilfs_sufile_set_suinfo(struct inode *sufil=
e, void *buf,
>   * len:                number of Bytes to trim from start
>   * minlen:     minimum extent length in Bytes
>   *
> - * Decription: nilfs_sufile_trim_fs goes through all segments containing=
 bytes
> + * Description: nilfs_sufile_trim_fs goes through all segments containin=
g bytes
>   * from start to start+len. start is rounded up to the next block bounda=
ry
>   * and start+len is rounded down. For each clean segment blkdev_issue_di=
scard
>   * function is invoked.
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 893a504cb80c..65f44ff6779e 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -654,7 +654,7 @@ static int nilfs_statfs(struct dentry *dentry, struct=
 kstatfs *buf)
>                         /*
>                          * If nilfs_palloc_count_max_entries() returns
>                          * -ERANGE error code then we simply treat
> -                        * curent inodes count as maximum possible and
> +                        * current inodes count as maximum possible and
>                          * zero as free inodes value.
>                          */
>                         nmaxinodes =3D atomic64_read(&root->inodes_count)=
;
> --
> 2.48.1
>
