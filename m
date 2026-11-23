Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795431993;
	b=NKyChZL7u4wiXX56kdFNjtcxcO6blgnwRFpjFJAtCL0L/jdKv2BFpk1U/UirYz+54UjU
	 CTrX1Ph3ela8G+f/NANw9k0w8TRBEf5jTB/T5o4jNdiulBgSLJPqmfVIOsxBtssanJY3O
	 zk4+iD+jCufoQpR4ddwTHhDLidAbX+RmyS72dZn9rgiVUwNc3vx2yvFHtStSowTK4Nk3R
	 h8BlwTCxJbgWZRc1YDBcU8QDOEk9lEyM5czvLVuNgzJ36UdkH2p6hVA27fbLExgwumefX
	 M5aZQ8/YBilwlyvH9oVBcVZ68gOKo8QCPMgRK3jbMt1T2sj2gT1xltdRb5q9Ir6yfTw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795431993;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=mT+7iZ0L4uTmqRV/CPpfhGnBZw7mXZec5VOgUOfCSzo=;
	b=E21c7RL7I/NPyUAiFKOa+mucHiJsfF9Hi0R3X1+/w8D4dCFNec1zdYqwjjOUtaUaOkto
	 PZy00HTLIuQ9q2dlR15cGKXqnahrGH+6g4BI5+BAaGlzk8tSG+rvDQy1qOYZB+rf/eWBc
	 qN5leRj6j/Z+0xk1qB20e7yPH3cIvnMmzX2TvpiINhs9XCsx2xRBYyKl0wCB6coMjAkZj
	 ky0r+9uRNsDbXBxn+XzhHOf/jQj+Ar9aHF1UP6dHDd+fB1E/al3X/SwP8vP67NoCDxcV9
	 YM7B2tgVpfaEa0ziC0pjzqCFPmAAL02uvOCmGshbseSkrSgRsUipPgpoxw5D7BSdeEw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cgDhJQTI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4379F606A31E
	for <linux-nilfs@vger.kernel.org>; Mon, 23 Nov 2026 11:06:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4379F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cgDhJQTI
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4b52fcb410dso189082f8f.1
        for <linux-nilfs@vger.kernel.org>; Mon, 23 Nov 2026 03:06:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795431992; cv=none;
        d=google.com; s=arc-20260327;
        b=X4vr6ANCKZm+rFHHiAQhKcK5wOvtPGCx1d3hKrY9ulItifQklBKLfsVwhxIyfFFl3P
         ezjTLM/138um8wzmm0LK9arqc3siO/HTF1acp0ODHNyBLjU5Gges+oJy0mcjh3AmmsSx
         jUifgBQZTzVquZaK4QAMthMdht+i++APyXodLxNcyLNVmSEQApo+qJuZTOD72uNwOfG9
         zbfsOkKoLp6O7tu4NKAqio5M/qv7KnNCbt6F9jKXVGLhpL4NZt39HUNmDzfgbMYYYXd0
         pbHruZVBpqkrO+WkqqdeTmLpW6evbEci2eUelxLrV+yiPkkUoFvIvPS1myKtvtYrULds
         z+pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mT+7iZ0L4uTmqRV/CPpfhGnBZw7mXZec5VOgUOfCSzo=;
        fh=/J4KlwvJ6rprUl0/ZBMR9XqetF/ZISyIHLO6APXLTpA=;
        b=hHMtlJqHbRfPFmfl3bhcHVVv+vTGEHCCEKbygehvGTE1z4gq2NdWqQkRwfgsXaF5LJ
         vuFokbrdAIL4iMVaFlRiQ5wNHdIFDViRree2JG3hAt9CqheAzmZ9vEbt7edoU47+BlSB
         /l8h+qdHZa1xdDQBoWtLV4pWNpoJwjH3LpfvBTOK49vUh9VIEChqZD6ifM9oNP+lB/Qb
         11LQ4jjQXxBWYpEoqiH6vzsWPIybPsQe3ex8A4mMyoa3yXVk6K4hubvQUkEoxoOVOpkh
         IgpdG+VBvxBIaHva4kOgvcGkcqlUGGFc3AAi5kL+wuBp08kVph4+TTOlNo9ECA7Dr0qi
         Rcsg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795431992; x=1796036792; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mT+7iZ0L4uTmqRV/CPpfhGnBZw7mXZec5VOgUOfCSzo=;
        b=cgDhJQTISwdZLM3hk0p/7dDXZs/iE1Nk6ov4ZiW7w9yFyZMLI9xzmMan1n+RmU3zBW
         UMcPh0BCQHoe8BI7c8JZ/AZMqe0dCOzvmN94cEq+B0l1W7PmLeztCdiy61j3gDDnpoR/
         YBYfA8q8OTFJphXrz5doTkiDfDav6vIBYThZv9UjwxY2CLdsdbvKnVs9+7EslGzI9a7m
         fmvbNx+1xz+KmbKVwcS5emLGm0sXoq7UoAPDiCS2HL2PlhQLD6iBNsp7TfIkfbUghMpb
         Zf4SOhMflghTwXer/+Db6boVwv1uN4NkJJUCI0/EA7jgDzVgIQMuyzEbqujTr3oCqsv4
         +C1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795431992; x=1796036792;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mT+7iZ0L4uTmqRV/CPpfhGnBZw7mXZec5VOgUOfCSzo=;
        b=pDksAv55bbpsmMONJNUX1MY3tPR6hWViVt/nWk7Og2hxxhMmlXsSR/FACY1/c9E3Dr
         He6i955McsMVSgufCGfhZeEWTUzduEo2XVONrXm1Ehql5TlppS0SSM8qUNZ+BxFKDtNw
         B5OnAkFJSJeeQV+BWc1etw1iHdugVefoAch6jdwp5/w3qbcK0GO6MPw2BMJik3/W0gok
         dzYSuzos2vIB9hxu4OtVzduPG0O4qbuFF81NyYExzIiZEgnNRShdG3W5wOmPKdu9epFE
         te+AVTKTHOfhEEmn3qF1jEqAI+haHwakHNfrcSTVRSGoD6bkAolrVnXz/ZN2YHkfj53A
         rGnA==
X-Forwarded-Encrypted: i=1; AL+hErFQTzwak1fOOG52lcYxeEnJ0lwX6iUpIMnW3M0+vgp4Hvj4ognUXSxLwGHvO3FV+9CEPBaUuilEyF/ThQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z/dfv2bdvx3C3bn0nAzm2jbszGNrbWq2rZ62RwCvOPA5+RbKNE+
	7u1EX1J7GQyteH9oBlWX0hu1xIyY1ta1KnTaLDwccSJdBsTawJ/BLNVQ1oPWtbzoCiIFmDFgHEp
	NKlgEtK6wGh1C4aZpHp+GVU+vyo0uB0kNWvA/
X-Gm-Gg: AZFdTZeVsnxwzKXJcEGKNsDOkpDejZXenDYvBsK84Zi0GVDvTBEvK2+Necjv2YU8jOh
	8ZGAan68pcMwq77DiiLY7wXPqrd8H2ilSIPf/POWaIB1EziXvwHggE1z07QrFsT8HfyZPB7OCE8
	SovABT0CeLup3GoN8i7qBlts5abr1lAdZbcfduqOjeti01cBCdy/GSJubvRB0Tg5MxsiWhNVJNy
	B6DQNFrGK0u/d/fWFvI6vA1Q3sAvvi7Ik9i68DEWku+d+6JJRDEbSdP/NwXX9Kt1xtn34yZpkPZ
	MlZtbpdTT5+WVLm3KQDEo9meaZXJCvzjNLIQx5wQPfXqbfVOvwZt617movHNAxqRJJZE+tMGaX9
	ZOR/zlMnO+MnWYcyWO5iwGXwcwepg68QTzRj3IA==
X-Received: by 2002:a5d:45c9:0:b0:49d:f98f:4666 with SMTP id
 ffacd0b85a97d-4abb0f3c85dmr16899244f8f.11.1795431991351; Mon, 23 Nov 2026
 03:06:31 -0800 (PST)
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Post: <mailto:linux-nilfs@vger.kernel.org>
List-Help: <mailto:linux-nilfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-nilfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119083809.3918948-1-wangjianjian3@huawei.com>
 <CAKFNMokeofZ8NU+nbn+FnYHNuQi5JJKhC_oS5+=bH-vhgrOUJg@mail.gmail.com> <70c39f48-e9af-44a0-b9de-ebafe285fd10@huawei.com>
In-Reply-To: <70c39f48-e9af-44a0-b9de-ebafe285fd10@huawei.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Mon, 23 Nov 2026 20:06:13 +0900
X-Gm-Features: Aa3M54qz_073V4ixwCx9cwYYLWWt-qTL5WQ5AnTC2ydnlkGzuMn1NhS4oJy7Hjc
Message-ID: <CAKFNMomnLBAwvZhua-BygyT_MGyWv6Ka1AggO7cwm-y-YMYmeg@mail.gmail.com>
Subject: Re: [PATCH] nilfs2: fix leak of gc inodes on error
To: "wangjianjian (C)" <wangjianjian3@huawei.com>
Cc: slava@dubeyko.com, linux-nilfs@vger.kernel.org, fengaojigui88@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 6:47=E2=80=AFPM wangjianjian (C)  wrote:
>
>
> On 11/19/2026 7:32 PM, Ryusuke Konishi wrote:
> > On Thu, Nov 19, 2026 at 5:41=E2=80=AFPM Wang Jianjian wrote:
> >> Zhengzheng reported below syz problems:
> >>
> >> NILFS (loop5): disposed unprocessed dirty file(s) when stopping log wr=
iter
> >> VFS: Busy inodes after unmount of loop5 (nilfs2)
> >>
> >> The reproducer called ioctl clean_segments on a corrupted image. It's
> >> first argument is { ino =3D 8, cno =3D 0xffffffffffffffff, vd_vblocknr=
 =3D 34,
> >> vd_period =3D [0x30000000000000, 0x10), vd_blocknr =3D 6, vd_offset =
=3D
> >> 7,...}.
> >>
> >> nilfs_ioctl_clean_segments
> >>    nilfs_ioctl_move_blocks // gc iget 8, get one inode reference
> >>    nilfs_clean_segments
> >>      nilfs->ns_gc_inodes move to sci->sc_gc_inodes
> >>      nilfs_segctor_construct
> >>        nilfs_segctor_do_construct
> >>          nilfs_segctor_assign
> >>            nilfs_segctor_update_payload_blocknr
> >>              nilfs_bmap_assign
> >>                nilfs_btree_assign_gc
> >>                  nilfs_dat_move
> >>                    // since there is no dat entry for vblknr 34
> >>                    // (entry->de_blocknr =3D=3D 0), return -EINVAL
> >>                    // fs will be remounted to readonly
> >>     // clean segments loop will be break because readonly fs
> >>     nilfs_remove_all_gcinodes
> >>          // since nilfs->ns_gc_inodes empty, it
> >>          // clean nothing
> >>
> >> ioctl_clean_segment will get one extra reference of inode 8 and when
> >> segments construct do GC move vblock 34 and do bmap assign, it lookup
> >> DAT table and get de_blocknr =3D 0, so it return -EINVAL. And since
> >> nilfs->ns_gc_inodes is empty, nilfs_remove_all_gcinodes will do nothin=
g
> >> and the extra inode reference won't be released.
> >>
> >> To fix this, splice sci->sc_gc_inodes back to nilfs->ns_gc_inodes when
> >> got error.
> >>
> >> Note that, when normal files add to nilfs dirty list by
> >> nilfs_set_file_dirty, it will got one reference and when
> >> nilfs_bmap_assign got error, nilfs_segctor_do_construct() also doesn't
> >> put the inode, but as a last resort, nilfs_segctor_destroy will do
> >> it(however, it doesn't clean sci->sc_gc_inodes).
> >>
> >> Fixes: 7942b919f7321 ("nilfs2: ioctl operations")
> >> Signed-off-by: Wang Jianjian <wangjianjian3@huawei.com>
> >> Reported-by: fengaojigui88@gmail.com
> >> Closes: https://lore.kernel.org/linux-nilfs/CAO-4RZ2=3D4okHYZ-xCkpV-ek=
j-aSqKLnYGOsRM9A2dD8R4Ozzeg@mail.gmail.com/T/#u
> >> ---
> >>   fs/nilfs2/segment.c | 1 +
> >>   1 file changed, 1 insertion(+)
> >>
> >> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
> >> index af0c3560444f..ea56a26041e8 100644
> >> --- a/fs/nilfs2/segment.c
> >> +++ b/fs/nilfs2/segment.c
> >> @@ -2588,6 +2588,7 @@ int nilfs_clean_segments(struct super_block *sb,=
 struct nilfs_argv *argv,
> >>    out_unlock:
> >>          sci->sc_freesegs =3D NULL;
> >>          sci->sc_nfreesegs =3D 0;
> >> +       list_splice_tail_init(&sci->sc_gc_inodes, &nilfs->ns_gc_inodes=
);
> >>          nilfs_mdt_clear_shadow_map(nilfs->ns_dat);
> >>    bail_unlock:
> >>          nilfs_transaction_unlock(sb);
> >> --
> >> 2.34.1
> > Hi Wang Jianjian,
> >
> > Thank you for the patch.
> >
> > Previously, once GC entered the loop, it would retry until it
> > succeeded, so the sc_gc_inodes list was always emptied by
> > nilfs_remove_written_gcinodes().
> >
> > However, since commit ce5a5ad1a833 ("nilfs2: fix infinite loop in
> > nilfs_clean_segments()"), an escape path was added for when filesystem
> > corruption is detected, which broke that assumption.  This issue
> > really should have been addressed back then.
> >
> > Ideally, the GC inodes on the sc_gc_inodes list should be discarded in
> > this error path.  Also, since the cleanup handling on GC failure still
>
> Hi Ryusuke,
>
> Which error path do you mean? The error handling in
> nilfs_segctor_do_construct() ?

Hi Wang Jianjian,

I am currently focused on reviewing another patch and want to wrap
that up first, so please bear with me for a little while.

I will most likely take your patch as is.  However, to properly handle
GC error cases -- including the additional GC-related bug reports that
have come in -- multiple fixes will be needed, and I expect to adopt
your patch as the first patch in that fix series. Please give me a
little more time.

When I mentioned revisiting the logic, I was referring to the entire
error path where log writing -- including the series of operations in
nilfs_segctor_do_construct() -- fails from that GC loop.  Originally,
the GC ioctl loop had no escape path on error because log writing
accompanied by GC is irreversible; while retrying is safe, aborting
out of it breaks consistency.

However, the current looping causes hangs reported separately and is
not desirable in the first place.  I am therefore reviewing all
operations performed by the log writer and their side effects,
examining what issues arise and what approach can resolve them so that
we can cleanly bail out when an error occurs during a GC log write.

Specifically, the log writer is implemented to undo changes on error
for certain metadata files such as the checkpoint file (cpfile) and
the segment usage file (sufile).
Also, the bmap/B-tree of regular inodes is designed and implemented so
that buffer dirty flags are not lost on error and retry, causing no
issues as long as they remain in memory.  However, the DAT metadata
file, which manages the translation from virtual block addresses to
physical block addresses, cannot be rolled back all at once once a log
write has started (doing so would break overall consistency).
Therefore, I am adding a new partial restore mechanism for GC to make
error bail-out possible.

I am working on this right now, and the direction of the fix is
already settled.  I hope to send it together with your patch to
Viacheslav within this week.

>
> > looks somewhat questionable, we may eventually want to split the error
> > path clearly.  However, as this works as a workaround, I plan to
> > accept it as is unless additional testing reveals any issues.
> >
> > I will run follow-up tests, revisit the GC error handling logic, and
> > then forward it to Viacheslav.
> And what kind of tests you you usually run ? other than normal fs
> tests(such as fsstress, xfstests, ...), do you have any nilfs specific
> tests?

As for how I test patches, I run the following checks and tests in a
local automated environment:

Style and static analysis checks: scripts/checkpatch.pl and make C=3D2
fs/nilfs2/nilfs2.ko

Build tests: make allmodconfig, cross-compilation for other
architectures (such as powerpc), builds with CC=3Dclang, and
builds/tests on a 32-bit kernel (686-pae)

Functional and stress tests: basic I/O tests (read/write, O_DIRECT,
sendfile, aio, etc.), iozone, fsstress, GC tests (nilfs-clean), and
NILFS2-specific mount tests
(https://github.com/konis/nilfs-test-tools.git)

For individual bug reports, I run the reproducers manually.  When
verifying specific features such as atime or Direct-IO, I also run the
relevant test cases from xfstests. Occasionally, I temporarily modify
the code to intentionally inject errors and test error paths.

It would be great to integrate these custom tests into xfstests,
though I haven't had the bandwidth to get around to it yet.  If you
would like to help out with that, contributions are very welcome --
consolidating them into xfstests is definitely the right way forward.

Hope this helps.

Thanks,
Ryusuke Konishi

> >
> > Thanks,
> > Ryusuke Konishi
