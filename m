Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03515276050
	for <linux-nilfs@vger.kernel.org>; Fri,  2 Oct 2026 01:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790906340; cv=pass; b=HFakBONoMvZKNUwO2SP6NjmrYyM+5EgpLOrk4CNLkDxOFtXBoVenr+K4yituORt4MImB6eaUfbs9cS5T2rjgbyFQMxicRWo6VvZxmRenVY+L6W5uyAGad06UTp9desjwpNRHux9FAmJHhD19aJKDtBgaV3drlcHbz93Rq+DOd8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790906340; c=relaxed/simple;
	bh=5tSo3lVtYLnOcRBnZ8Uka6zHCVp5BYev9wifdMLO2yY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mbzCW05sqT3IQ+C1aHcwP3U9eRQKeLCBCVC03y8swUx9DJSzgpp97o7odA+xppVUquB/BxOWM+ESAgqMW/iF0A08SUcLAQT9tB9+r11jitOHXRPHxVVGU5rCOlY+UJbs40Ugbdjg/IaEgV/uFllq6Z9OxoHEpHxjh/sb/cD0QBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CsM3UUJj; arc=pass smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CsM3UUJj"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49cd5462b69so39710915e9.1
        for <linux-nilfs@vger.kernel.org>; Thu, 01 Oct 2026 18:58:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790906337; cv=none;
        d=google.com; s=arc-20260327;
        b=sSW9Za1XG1C6BJtI3QfHjUcLGFLC2yMxbioM5v7FoW1YDE44zN58BcOtOqYjZQYUbt
         R4yhbdBQ03TKRm1zx+CXklPhDv9Mg1u6esBxT/5v47FwVt5C5KnHYQHIJDIdsLJ1Wqs4
         iTzo2QSIdH2/7+RKq4w+XhIkYBqM+927li7vX5t8EFmLcy88/Yp2WaeVF8EyRiGwBSQ0
         +Jt3MpeP+h7ImiUEZIkkDRQq8EfsT5c9ZJqbZKmhZG0PzgLyZr+UeeD/hUonftQJvRJV
         li3DKzZ4ND5EWiaih4+RuPYuVnd0xJ85mxEiGpgHOraRFvibyauPt7Uoq8TAe+LXRm4I
         q9yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Fu4LAzeyim+LR9egQbhsNOuxSh77uf7Tv4YHxIhvJzs=;
        fh=RI2T3fwfUmwRYTCM5RxtpbDp9fWZzIlTQvVtqNtQ/9Q=;
        b=Y3XYS7de1qzV5WCWZoFunoyE+QcWWUwrufCMoMx00rQF0DXpPWT6Ue9SeLxZqFZ1XO
         S/xPcUzUI3qvFw9SiSVBrACEK5HUO2YAD/bt8PR8LCcldjEKY0HjYAgX/+wEHTv2GR0C
         p4+EZ5QpZgFTW1jlexl5jEPsszj/fFrH0yV5fgxqQ9k68cH/yPhWnJWR12NFo0uumVl5
         I2AGXSdgblqKAjH6e1v3ZvvXJVBGWNbVvOmrnGQ7TUaUCa0eydydv/JmNxl9JvhmtnzB
         QNq2rN7bCfEhhx5jZs0/7PrPgzkK6X9Vi8tpWrZOVSqs57b8UF1AXSMXwKMqfgzPh9aV
         IEqA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790906337; x=1791511137; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Fu4LAzeyim+LR9egQbhsNOuxSh77uf7Tv4YHxIhvJzs=;
        b=CsM3UUJjmyCaF11qRo3dn3gD11uYKKWKJU8RjKzVcl2fSQez2Mbpsjgkm73ynWp03b
         LMp8C5HtG6u2bjZlwpXlc5wE6qJ8Wmp8h6rK6ofZnAM1a76zWjQB6nia+FIfLiDEg1bw
         MDDYZfhRBarJd6RTrxG+3SHXg03gVRspBRKUaxN7ZNFCOqy1IINGxI9cNktbjpV7iP0Q
         lgvffgFTEvSAH6u+RW/PX9GRNqJ80brds8DVKy96C35EdswVndQ/4SFtV6983DygxcLy
         eVCCd4mKWH0a57r9mnlQeggzYglk2AhsHaffIMOjfZcCfZODauCKaZrLm7UNgGuwleeb
         BTug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790906337; x=1791511137;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fu4LAzeyim+LR9egQbhsNOuxSh77uf7Tv4YHxIhvJzs=;
        b=rhEtA15zPt8y8IimYrTUHvRJCNcwV32eWEy7jW3DX6yN+yv/VBg4fVimD+5Fwm/232
         XDC2QlX9bTiYJmT9Nn6aN8hi7euo5SLQNLXYh9IzaYixRKgpnzImA5RAqCnGux3y59QL
         gHzXogHq9by5fhHDhX0vGLkQSbnhKcR26ki+yITx4FwMoWGw5HSnN/AAiFfqF7vmw/uc
         apqCKSjt61GE3GHffDe6ohcjhqhQ4pI9vD530tNEEKTZuNaRNQYfnX+8C5MF4ITL5OLx
         WheskGWnnxGQInMERzopvXCdubzxHekT3vD5J4zVUxoEx0FPeSDXGcptCL1ZGgmlt3av
         SALA==
X-Forwarded-Encrypted: i=1; AKwUvBz9odhOLy4BFv8PEPfYCnwSRa4ysWtpykl0sS8OfZcBbI90ac650gJ4rfJ9NyGjGHLtJbZbqe8tLvBwhw==@vger.kernel.org
X-Gm-Message-State: AFuF++m9Ihl4E94StVIeSRhLWFjDCaTCNwGvaWqw9NVpukzxRJVruVYi
	RPJ+GHQzPf0y6OGJIUaXVvzC644nt6Hy64DEOGhXYc81kP1zUi2ODEmxuFxqKDQD8JCD7j9YmWY
	oAwxICxIm5z5wal3yDodcSCjAmevF+//sKxNRcHw=
X-Gm-Gg: AYBFou0cSCLMTH9D0ESKeDQmK25VJppKLCunF2hngaFWIRkYDndlFy82rg1rdHJf1VA
	iDzxrLtDxDJryhIQdNfSPQVtLi4JgqF14wXy3d+wxg8lNk0qBF8XOb46yPzLtWqQLidm+uabTs2
	1TPs7SZzocgklZtpunZYBUcIEf7sOlPemmomBAziWDHc/7mQnnYfecXL53LxccnvPnbw1Q8gYnG
	BilH/pQTLx9Hjq9R6irTf7I2gXx+iiBjf9Dsk6JZ5Veyj49KskNYIHdV3t3ENVzsfEoS2pOum6a
	IHfKhhx/toeJfLRXLtciH2q1myGqBL5RNqoLFenRHUjrz5mnij5TzuMl
X-Received: by 2002:a05:600c:154b:b0:4a0:1559:bafd with SMTP id
 5b1f17b1804b1-4a027573e97mr21739115e9.8.1790906336899; Thu, 01 Oct 2026
 18:58:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260920205533.426028-1-southampton.jake.labelle@gmail.com>
 <20260930000954.371774-1-southampton.jake.labelle@gmail.com>
 <20260930000954.371774-3-southampton.jake.labelle@gmail.com>
 <CAKFNMok2oRBaSxmRLOs1+g6LWDbDAcstg1myzRjZ=y6t_mf-=w@mail.gmail.com> <CAKFNMokQ_iwmSig2PruoncoxqhTNCYrzYSp+KMF=6vMjct12JQ@mail.gmail.com>
In-Reply-To: <CAKFNMokQ_iwmSig2PruoncoxqhTNCYrzYSp+KMF=6vMjct12JQ@mail.gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 2 Oct 2026 10:58:40 +0900
X-Gm-Features: AclHuK9AI-qrFPwyNx5McIaWyH9bVAO1_VA3ns6b-UNJjJoDAk-h1MZKTwpUqsQ
Message-ID: <CAKFNMokwGHQabG-W-zmo3kwFnYAj5ZJFFNGH6szv7F49gwo3Hg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] nilfs2: validate directory position after llseek
 in readdir
To: Jake Labelle <southampton.jake.labelle@gmail.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 2, 2026 at 1:50=E2=80=AFAM Ryusuke Konishi wrote:
>
> On Fri, Oct 2, 2026 at 12:53=E2=80=AFAM Ryusuke Konishi wrote:
> >
> > On Wed, Sep 30, 2026 at 9:10=E2=80=AFAM Jake Labelle wrote:
> > >
> > > nilfs_readdir() uses ctx->pos, which userspace can set to an arbitrar=
y
> > > value via llseek, as an offset into the directory folio and parses
> > > whatever bytes sit there as a directory entry.  A position pointing
> > > into the middle of an entry -- or at unused bytes of a corrupted imag=
e
> > > that the page validator never inspected -- makes dir_emit() copy up t=
o
> > > 255 (name_len) bytes from a bogus entry, possibly reading past the en=
d
> > > of the folio and returning unrelated memory contents to userspace.
> > >
> > > Snap unaligned positions onto a valid entry boundary by walking the
> > > rec_len chain from the chunk start before parsing, as ext2 does in
> > > ext2_validate_entry().
> > >
> > > Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
> > > Co-Authored-By: Claude Mythos 5 <noreply@anthropic.com>
> > > Signed-off-by: Jake Labelle <southampton.jake.labelle@gmail.com>
> > > ---
> > > v2:
> > > - Hoist the repeated nilfs_chunk_size(inode) calls into a local
> > >   chunk_size variable, matching the existing style elsewhere in
> > >   dir.c (Ryusuke Konishi).
> > > - Expanded the comment to explain why re-validation is only ever
> > >   reachable on the first page of the loop, and why any chunk-aligned
> > >   offset -- not just offset 0 -- is already a trustworthy entry
> > >   boundary: no on-disk rec_len chain crosses a chunk boundary, so
> > >   chunk alignment alone (regardless of the variable-length entries
> > >   within a chunk) is sufficient without a chain walk; a walk is only
> > >   needed to recover from a non-chunk-aligned offset (Ryusuke
> > >   Konishi's question, answered on-list rather than in code).
> > >
> > >  fs/nilfs2/dir.c | 33 +++++++++++++++++++++++++++++++++
> > >  1 file changed, 33 insertions(+)
> > >
> > > diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> > > index 8b53802b6..bc8cb21c7 100644
> > > --- a/fs/nilfs2/dir.c
> > > +++ b/fs/nilfs2/dir.c
> > > @@ -231,11 +231,27 @@ static struct nilfs_dir_entry *nilfs_next_entry=
(struct nilfs_dir_entry *p)
> > >                                           nilfs_rec_len_from_disk(p->=
rec_len));
> > >  }
> > >
> > > +static inline unsigned int
> > > +nilfs_validate_entry(char *base, unsigned int offset, unsigned int m=
ask)
> > > +{
> > > +       struct nilfs_dir_entry *de =3D (struct nilfs_dir_entry *)(bas=
e + offset);
> > > +       struct nilfs_dir_entry *p =3D
> > > +               (struct nilfs_dir_entry *)(base + (offset & mask));
> > > +
> > > +       while ((char *)p < (char *)de) {
> > > +               if (p->rec_len =3D=3D 0)
> > > +                       break;
> > > +               p =3D nilfs_next_entry(p);
> > > +       }
> > > +       return offset_in_page(p);
> > > +}
> > > +
> > >  static int nilfs_readdir(struct file *file, struct dir_context *ctx)
> > >  {
> > >         loff_t pos =3D ctx->pos;
> > >         struct inode *inode =3D file_inode(file);
> > >         struct super_block *sb =3D inode->i_sb;
> > > +       unsigned int chunk_size =3D nilfs_chunk_size(inode);
> > >         unsigned int offset =3D pos & ~PAGE_MASK;
> > >         unsigned long n =3D pos >> PAGE_SHIFT;
> > >         unsigned long npages =3D dir_pages(inode);
> > > @@ -254,6 +270,24 @@ static int nilfs_readdir(struct file *file, stru=
ct dir_context *ctx)
> > >                         ctx->pos +=3D PAGE_SIZE - offset;
> > >                         return -EIO;
> > >                 }
> > > +               /*
> > > +                * ctx->pos comes from userspace via llseek and may p=
oint
> > > +                * into the middle of an entry -- or at unvalidated b=
ytes
> > > +                * of a crafted image. offset is only nonzero here on=
 the
> > > +                * very first iteration (subsequent pages always star=
t at
> > > +                * offset 0, which -- like any chunk boundary -- is a=
lways
> > > +                * a legitimate entry start, since no rec_len chain c=
rosses
> > > +                * a chunk boundary). Snap a non-chunk-aligned offset=
 onto
> > > +                * a real entry boundary by walking the chain from th=
e
> > > +                * enclosing chunk's start, as ext2 does; otherwise
> > > +                * dir_emit() copies name_len bytes from a fake entry=
,
> > > +                * reading past the end of the folio.
> > > +                */
> > > +               if (offset & (chunk_size - 1)) {
> > > +                       offset =3D nilfs_validate_entry(kaddr, offset=
,
> > > +                                       ~(chunk_size - 1));
> > > +                       ctx->pos =3D ((loff_t)n << PAGE_SHIFT) + offs=
et;
> > > +               }
> > >                 de =3D (struct nilfs_dir_entry *)(kaddr + offset);
> > >                 limit =3D kaddr + nilfs_last_byte(inode, n) -
> > >                         NILFS_DIR_REC_LEN(1);
> >
> > Hi Jake,
> >
> > I ran some local tests with the v2 patch set and noticed a boundary
> > issue when seeking into the middle of the last directory entry in a
> > chunk/page.
> >
> > When 'pos' points to an unaligned offset inside the last entry (for
> > example, offset 19 inside '..' in an empty directory where 'rec_len'
> > spans up to 4096):
> >
> > 1. nilfs_validate_entry() walks the 'rec_len' chain starting from offse=
t 0.
> > 2. 'p' advances past the last entry, so its address becomes 'base +
> > chunk_size' (e.g. 'base + 4096').
> > 3. The loop terminates, and the function evaluates offset_in_page(p).
> >
> > When page size =3D=3D chunk_size (such as standard 4KB block setups),
> > offset_in_page(base + 4096) evaluates to 0 due to wrap-around.
> > As a result, nilfs_readdir() resets 'offset' to 0 and re-emits '.'
> > instead of reaching the end of the chunk or EOF.
> >
> > Could you adjust this so that reaching the end of a chunk yields
> > 'chunk_size' (including cases where 'chunk_size' equals 'PAGE_SIZE')
> > rather than wrapping around to 0?
> > This could be handled either inside nilfs_validate_entry() or by
> > detecting the wrap-around in the caller and rounding 'offset' up to
> > 'chunk_size'.
> >
> > Also, when revising the patches, could you update the AI attribution
> > tags to use the "Assisted-by:" tag format as mentioned in my reply to
> > the cover letter?
> >
> > Thanks,
> > Ryusuke Konishi
>
> Hi Jake,
>
> As a quick follow-up regarding nilfs_validate_entry(), I think it is
> better to change its return value calculation from:
>
>     return offset_in_page(p);
>
> to:
>
>     return (char *)p - base;
>
> If p reaches the page boundary (PAGE_SIZE), offset_in_page() wraps around
> to 0, which could cause unexpected behavior in the caller.  Returning
> (char *)p - base avoids this wrap-around and yields chunk size properly,
> allowing the caller to safely terminate its loop via the boundary check.
>
> What do you think?
>
> Thanks,
> Ryusuke Konishi

Hi Jake,

I have one additional piece of feedback regarding the commit message
and code comment that I would like you to reflect in the patch set.

Looking closely at the commit description again, the statement:

"possibly reading past the end of the folio and returning unrelated
memory contents to userspace."

appears to be inaccurate for the original nilfs_readdir() implementation.

Because the inner loop enforces '(char *)de <=3D limit' before
processing any entry (where 'limit' is capped at
'nilfs_last_byte(inode, n) - NILFS_DIR_REC_LEN(1)'), an unaligned
pointer that points past 'limit' fails this check and never enters the
loop.  Therefore, it cannot read past the end of the folio or leak
out-of-bounds memory contents to userspace.

The actual issue is that an unaligned offset within the valid page
boundary parses arbitrary bytes inside the folio as a valid
'nilfs_dir_entry', returning bogus/corrupted directory entries to
userspace.

Could you update the commit message to reflect that the bug is parsing
bogus entries within the folio, rather than out-of-bounds folio
access?

Similarly, the last sentence of the comment added inside nilfs_readdir():

"otherwise dir_emit() copies name_len bytes from a fake entry, reading
past the end of the folio."

also has the same inaccuracy.  Could you update that sentence as well?
 For example:

"otherwise dir_emit() copies name_len bytes from a fake entry,
returning bogus directory entries to userspace."

Thanks,
Ryusuke Konishi
