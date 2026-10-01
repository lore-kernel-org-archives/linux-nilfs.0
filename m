Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B783E316E
	for <linux-nilfs@vger.kernel.org>; Thu,  1 Oct 2026 15:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790870015; cv=pass; b=tqOf8Q+yuHz8Wzs0wJkYJ8aSBiMzXqQb+pZCTzQr7dhEzR80yikOQhRIvvxxMIqxZ4fSk02Ewoxoy0ycDPo0Ale1Q6QhHWbrkwdF8Bi0nmJX/mjenfk5/0GzBdZvvJ9FuX9Tw+T/g8mEoWygxpXJVkCB1V/Oc5H46E7J88fi1aI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790870015; c=relaxed/simple;
	bh=nrqq7JAjvZx3WrPqkMg8Bj+Eutz0xThwGCBDPDOeivw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UHTtC5zGr0rzw54ebd514AQ3wDhuLJeCXpwENw6rvPcEMnS2AAOPfQHQgZszNIdV6X1iZ6OkItUvkR0qXMnC6cmcuhSKC3M1jz49cWUDy/WGrhdTlrs6t8RyuPNoIREwulPl+C5IMGza1vTRzgOxaQ9aPT4lzIrm3T93XQVPYM8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lpNxYioo; arc=pass smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lpNxYioo"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ffe281cb1so35241385e9.1
        for <linux-nilfs@vger.kernel.org>; Thu, 01 Oct 2026 08:53:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790870009; cv=none;
        d=google.com; s=arc-20260327;
        b=jk675Dxgt5b1jBLe2VUguI2zXIpIvA76hwPrXODv+6JVxjrUXDimVmZ4DwODk0tFuY
         0cYkPW1sL4yvbcZl88OEpwN4PKMJbQuV61INWrdeQDrayhMOQD9yiQkDyiNPVB9RsWh+
         4+Jaq24DHi0HWYEh9uFteyAqBTF51ze8fAg23Gheff8v8R7YXkLoZDEsGc0B04OpzeEu
         ATnB1+yXRZPVUMkpv85fqgdWfJDWxHyKy6/g5LX/GLQlCyAOAPe6I5MwKj1HYCilFtFq
         q/i7w/Dv5Qrz8vgsrHGRiqov6PEITaIxmQKmQarWHpEvEwrUm3Je/O5qISc4NSyfGEpD
         MK0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=INKgLFbUmNyQ6zL4LhYu6aCcZAwOF+ikWwq35kn5VYs=;
        fh=+J9GPirungP0N0WbqZ2QkYyyOHrYbc3xOA57082j6NA=;
        b=FR1MwRBoyPQFw/qK2lMCfHrIQYsMZxQ5D5e+ZFWOf6M3LDZ92w3EP1PMCGycFQp0Dh
         DhQhlKnrBmAxATnHDEyUWDfw2aVqQ6eK8bn/4nvjtQmvRg9wEKt/zco6ZKVIHC2uDjFA
         0dhhnyeIFRgUYuitdBFSYwWtys1nlAGL05YJcBCn+nYr6c5pLq/zJl4Ajm+XLrg+UCvZ
         cFtOvRWusqXG1DfIrhRcnPC0UIUaPo4FRwNZO4NrJBxgIEzPG1FK8ccdsQFrHDShaR9Z
         oeh4+D7uuioJdzVCr7hhM+iZSlaUb3pIqYoX1oIcGyk5SncsXN3yM4qfbJdbTS7a1sK4
         DLDA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790870009; x=1791474809; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=INKgLFbUmNyQ6zL4LhYu6aCcZAwOF+ikWwq35kn5VYs=;
        b=lpNxYioo0j6eoRHU0EIUQXXVmc3fvKFGwEagOoA/c2+VrGjrwV8BHR42k/0jMCXL8L
         zqrZ9Z4RASC4hOprRx0Tbch01z3oUIV+SbG6EAXtmX2h9qHr+CRIdZIaqq1kbYi6Pq+U
         UkMkUStJc0eBvBUTNDZSb0AcOBlPxW+G2+bLJ/DK/ZaUj7C4VXdv4qurifO93zWb3K9R
         sRLAxOYGrdgXmjWcoQuJJABlIMzRTEnkmygeuWVPaoLPKRQ13OwlPJnMVSAqlVZJJAti
         rwBDI3O3aK9sWrY8xhITOBf6VHpw9P4j96sdEx6gti3UfvH16nmvzsTDbWKFkqtJMegt
         cvJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790870009; x=1791474809;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=INKgLFbUmNyQ6zL4LhYu6aCcZAwOF+ikWwq35kn5VYs=;
        b=UQYy14r0dVh3A9kOkHSkuAg7zkwmPd4gP84+5azWhVNHb3TFGuSfNy4Cfs0GUEci3Z
         yuQ48t2fzHALQ5IZtvK+cv+usImv2p2UtQcUg+x7tdjAC/FQUf7FLa5Y2q6HN3w0EQ7B
         EgfHhbGsD1FYPXdMuJ0oJdJnmTd6maso2wOPmBtzc2UW2SKXFwLn/spB25JUUvKXcCsz
         fjST6MoW1WRsMe6O96G5ffdVEeSVPFvnXiFNgG3hVMcMKg2UYLMP+b4IEAtqErJROtTd
         OZ07jHwaHgM/yTIVhHsT+ABOizdb9PCbCeolY2h6arMnsCgXaqqMmphininGSOg/eEvo
         1/sg==
X-Forwarded-Encrypted: i=1; AKwUvBxyJLBSe6EAEyt91rGL7aAtXNZILUZwRq8Z1ku+zqXFm3BT/wyo/nWgPrv7WxF5DXFsbBTxa1Xg6IQAEg==@vger.kernel.org
X-Gm-Message-State: AFuF++l1zctV1D4uaWZIZJyUOHRDdbDD9g1OKaiIc13ulrfb9Mo8nrW8
	IuYAvCXgRil4G1HDggbA/kUHCohttRPb0fQcx0lKV3acwM65xdvn64sABqDktxa8H979xf9bdQR
	063n4SpflrtvuF/pjjtnOkAAg8izoskI=
X-Gm-Gg: AYBFou0iidvQrMLYYwtNm3nBX+QBt+QS5D/WqYbT7sEE0PzT2piqLsoB4goO9IY7qA4
	zLMBZmS5yK9cgBHYqYtwYodZXFAOurPwwhqfWehHgtVmmIcOcMHIGSCVfXtd6SEYXS2y1ycy/dE
	wOjWEH6mkw3CNxuC/mKryYTBJSvov7EMxmRzZSyqO6ASLeMqkGP/zuGSluhq55pQ+YvkuqW+EJ2
	N5G+3enKP9AF11i9tWU+xe7nK8hWGDEpbBsOnV9sZSEt/IL4ObpadBJHSvL8Rx24aE6U9cnHq1R
	78iYVzENyDR582ZLUFNZLlvT9gIo0Ip1u1aZBeLnquXCqnF5QXaVq4Fwe3252Dui0wQ=
X-Received: by 2002:a05:600c:3510:b0:49f:f963:7093 with SMTP id
 5b1f17b1804b1-4a02769b3afmr513405e9.23.1790870009384; Thu, 01 Oct 2026
 08:53:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260920205533.426028-1-southampton.jake.labelle@gmail.com>
 <20260930000954.371774-1-southampton.jake.labelle@gmail.com> <20260930000954.371774-3-southampton.jake.labelle@gmail.com>
In-Reply-To: <20260930000954.371774-3-southampton.jake.labelle@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 2 Oct 2026 00:53:08 +0900
X-Gm-Features: AclHuK_yxztCzsWON3-qvSgqEg9vUqzgDB5U23pBPcioAo6Dutz89duNdESHCTs
Message-ID: <CAKFNMok2oRBaSxmRLOs1+g6LWDbDAcstg1myzRjZ=y6t_mf-=w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] nilfs2: validate directory position after llseek
 in readdir
To: Jake Labelle <southampton.jake.labelle@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 30, 2026 at 9:10=E2=80=AFAM Jake Labelle wrote:
>
> nilfs_readdir() uses ctx->pos, which userspace can set to an arbitrary
> value via llseek, as an offset into the directory folio and parses
> whatever bytes sit there as a directory entry.  A position pointing
> into the middle of an entry -- or at unused bytes of a corrupted image
> that the page validator never inspected -- makes dir_emit() copy up to
> 255 (name_len) bytes from a bogus entry, possibly reading past the end
> of the folio and returning unrelated memory contents to userspace.
>
> Snap unaligned positions onto a valid entry boundary by walking the
> rec_len chain from the chunk start before parsing, as ext2 does in
> ext2_validate_entry().
>
> Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
> Co-Authored-By: Claude Mythos 5 <noreply@anthropic.com>
> Signed-off-by: Jake Labelle <southampton.jake.labelle@gmail.com>
> ---
> v2:
> - Hoist the repeated nilfs_chunk_size(inode) calls into a local
>   chunk_size variable, matching the existing style elsewhere in
>   dir.c (Ryusuke Konishi).
> - Expanded the comment to explain why re-validation is only ever
>   reachable on the first page of the loop, and why any chunk-aligned
>   offset -- not just offset 0 -- is already a trustworthy entry
>   boundary: no on-disk rec_len chain crosses a chunk boundary, so
>   chunk alignment alone (regardless of the variable-length entries
>   within a chunk) is sufficient without a chain walk; a walk is only
>   needed to recover from a non-chunk-aligned offset (Ryusuke
>   Konishi's question, answered on-list rather than in code).
>
>  fs/nilfs2/dir.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>
> diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> index 8b53802b6..bc8cb21c7 100644
> --- a/fs/nilfs2/dir.c
> +++ b/fs/nilfs2/dir.c
> @@ -231,11 +231,27 @@ static struct nilfs_dir_entry *nilfs_next_entry(str=
uct nilfs_dir_entry *p)
>                                           nilfs_rec_len_from_disk(p->rec_=
len));
>  }
>
> +static inline unsigned int
> +nilfs_validate_entry(char *base, unsigned int offset, unsigned int mask)
> +{
> +       struct nilfs_dir_entry *de =3D (struct nilfs_dir_entry *)(base + =
offset);
> +       struct nilfs_dir_entry *p =3D
> +               (struct nilfs_dir_entry *)(base + (offset & mask));
> +
> +       while ((char *)p < (char *)de) {
> +               if (p->rec_len =3D=3D 0)
> +                       break;
> +               p =3D nilfs_next_entry(p);
> +       }
> +       return offset_in_page(p);
> +}
> +
>  static int nilfs_readdir(struct file *file, struct dir_context *ctx)
>  {
>         loff_t pos =3D ctx->pos;
>         struct inode *inode =3D file_inode(file);
>         struct super_block *sb =3D inode->i_sb;
> +       unsigned int chunk_size =3D nilfs_chunk_size(inode);
>         unsigned int offset =3D pos & ~PAGE_MASK;
>         unsigned long n =3D pos >> PAGE_SHIFT;
>         unsigned long npages =3D dir_pages(inode);
> @@ -254,6 +270,24 @@ static int nilfs_readdir(struct file *file, struct d=
ir_context *ctx)
>                         ctx->pos +=3D PAGE_SIZE - offset;
>                         return -EIO;
>                 }
> +               /*
> +                * ctx->pos comes from userspace via llseek and may point
> +                * into the middle of an entry -- or at unvalidated bytes
> +                * of a crafted image. offset is only nonzero here on the
> +                * very first iteration (subsequent pages always start at
> +                * offset 0, which -- like any chunk boundary -- is alway=
s
> +                * a legitimate entry start, since no rec_len chain cross=
es
> +                * a chunk boundary). Snap a non-chunk-aligned offset ont=
o
> +                * a real entry boundary by walking the chain from the
> +                * enclosing chunk's start, as ext2 does; otherwise
> +                * dir_emit() copies name_len bytes from a fake entry,
> +                * reading past the end of the folio.
> +                */
> +               if (offset & (chunk_size - 1)) {
> +                       offset =3D nilfs_validate_entry(kaddr, offset,
> +                                       ~(chunk_size - 1));
> +                       ctx->pos =3D ((loff_t)n << PAGE_SHIFT) + offset;
> +               }
>                 de =3D (struct nilfs_dir_entry *)(kaddr + offset);
>                 limit =3D kaddr + nilfs_last_byte(inode, n) -
>                         NILFS_DIR_REC_LEN(1);

Hi Jake,

I ran some local tests with the v2 patch set and noticed a boundary
issue when seeking into the middle of the last directory entry in a
chunk/page.

When 'pos' points to an unaligned offset inside the last entry (for
example, offset 19 inside '..' in an empty directory where 'rec_len'
spans up to 4096):

1. nilfs_validate_entry() walks the 'rec_len' chain starting from offset 0.
2. 'p' advances past the last entry, so its address becomes 'base +
chunk_size' (e.g. 'base + 4096').
3. The loop terminates, and the function evaluates offset_in_page(p).

When page size =3D=3D chunk_size (such as standard 4KB block setups),
offset_in_page(base + 4096) evaluates to 0 due to wrap-around.
As a result, nilfs_readdir() resets 'offset' to 0 and re-emits '.'
instead of reaching the end of the chunk or EOF.

Could you adjust this so that reaching the end of a chunk yields
'chunk_size' (including cases where 'chunk_size' equals 'PAGE_SIZE')
rather than wrapping around to 0?
This could be handled either inside nilfs_validate_entry() or by
detecting the wrap-around in the caller and rounding 'offset' up to
'chunk_size'.

Also, when revising the patches, could you update the AI attribution
tags to use the "Assisted-by:" tag format as mentioned in my reply to
the cover letter?

Thanks,
Ryusuke Konishi
