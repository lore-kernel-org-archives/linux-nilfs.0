From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: Re: [PATCH] nilfs2: fix NULL pointer dereference in nilfs_segctor_prepare_write()
Date: Tue, 8 Nov 2022 20:10:36 +0900
Message-ID: <CAKFNMo=bbR+ZgJQosEoj=yfoY2y=PmYHVfz3CdLCvCWVK7igTQ@mail.gmail.com>
References: <20221108022928.497746-1-liushixin2@huawei.com>
 <CAKFNMo=n8_NkHzvxOBuiU4XahdRnWNbwmZKu4pw0KZ7bfWuVhg@mail.gmail.com>
 <5c8dd545-2190-162e-a9de-2323fcad716f@huawei.com> <CAKFNMokcSj9YSLeXm=S4rY5nMx6DjQvRHXVaLVu2CbNEia7-2Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ljbpqeUpzJfqMkrUw95JFard8abiZdbIIeeNMaJgi7o=;
        b=OWFcdkRkt3mUC7aZDXwMSmKSkIjAiC/88vBm15uJO7ZbayYo0iQb9qG0oOsOgqJnoe
         4OtiDpZ2YTl1z/sKporedNlzRdVfYHUZ+/GqghpAVz1jpoKhTpPoKSU/ZVHp/oFOb0dm
         QGdNMZF6PhWQppBWZHdS4AUZHk5ogRWzwvVg2pDh9TPYXUxbmJ9rFHZNngQQfdGDjH/Y
         oynQaiOSjjArHRiRXWDMgCzmNvgO2KjxR04x5sbrZwJQ8Olm655W8ict3prlu0UWhzci
         UNTkn5GsfTA+W8PqLWzk+5aXne2BqxpU2kZIzZmP9Axm1CB2zTVPzbYFT1XHtxNUALC8
         4j2g==
In-Reply-To: <CAKFNMokcSj9YSLeXm=S4rY5nMx6DjQvRHXVaLVu2CbNEia7-2Q@mail.gmail.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Liu Shixin <liushixin2@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 8, 2022 at 7:33 PM Ryusuke Konishi  wrote:
> On Tue, Nov 8, 2022 at 3:49 PM Liu Shixin wrote:
> > Then in nilfs_segctor_extend_segments(), we set sb_segnum by prev->sb_nextnum directly,
> > and calculate next sb_segnum by nilfs_sufile_alloc(), since last_alloc is not updated,
> > we will get sb_segnum again.
>
> nilfs_segctor_extend_segments() pre-allocates one or more segments
> large enough to store updated blocks of metadata files that need to be
> written in a series of logs at once, and sets up a chain of segbufs.
> (Sorry for the missing function comment).
>
> sb_segnum is set by prev->sb_nextnum to form a chain of buffers for
> segments.  This is expected behavior.
> And, the sb_nextnum (= next sb_segnum) will be given by
> nilfs_sufile_alloc().   This is also expected.
> It looks like the problem is that nilfs_sufile_alloc() here allocates
> the same segnum again.
>
> Because sb_segnum is set by prev->sb_nextnum which is allocated by the
> previous nilfs_sufile_alloc() call,
> this usually does not happen.
>
> A possible anomaly is if the segment pointed by the first nextnum (or
> segnum) was not marked dirty on sufile.
> This may happen if the sufile is corrupted on the test disk image that
> syzbot provided (mounted).
>
> Can you confirm if this is actually happening?

If we can mount the test disk image, the state of sufile can be
confirmed quickly with lssu command:

$ lssu
              SEGNUM        DATE     TIME STAT     NBLOCKS
                   3  2022-11-04 23:23:49  -d-        2048
                   4  2022-11-04 23:23:50  ad-         103
                   5  ---------- --:--:--  ad-           0

Here, the flag "d" in STAT means the segment is dirty (in-use) and the
segment of ns_segnum or ns_nextnum is indicated with the "a" flag.
This is an example of a normal disk image.
Or, if it's easy to insert debug code to check, that's fine too.

Regards,
Ryusuke Konishi
