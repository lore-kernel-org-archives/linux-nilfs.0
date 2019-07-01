From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [PATCH v6 0/4] vfs: make immutable files actually immutable
Date: Mon, 1 Jul 2019 20:20:51 +0300
Message-ID: <72f01c73-a1eb-efde-58fa-7667221255c7@plexistor.com>
References: <156174687561.1557469.7505651950825460767.stgit@magnolia>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=plexistor-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RMtO9zTMwULPwpFiTkeooNGzR9zKo/UB7YgL+t4fgzA=;
        b=1wUdmopYsOTGEBPctCCQBJNp/Weny3U0OdMAgIX7XMpDLNjX7yi2BQKVOeIOZfgf1b
         I2dQPvs1YcMd4MKfGasxoR1vUF57n1uWvGfOwCBn+dFFXqdtzk7+nDTMfgxaIC1cMqAd
         CyXSD5wWJrsSE7f66iNNQpS8suPAgj9SNlBFoRgvaYPLl2O9hulyvjxbO8s6Guhj4y1S
         Nf6nnLqhsslQUJQ8lQjHCR002MedRLPvKNFje/NywIlwBVxr1dbYLS/Ag6d45MoLEFLA
         TB43Jl9ECXn6C3ClznsgSlBckfDR8AQM1se/327D0FreZlmY9S9DkHpcHai8gVFUiAbk
         jAnQ==
In-Reply-To: <156174687561.1557469.7505651950825460767.stgit@magnolia>
Content-Language: en-MW
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Darrick J. Wong" <darrick.wong@oracle.com>, matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, ard.biesheuvel@linaro.org, josef@toxicpanda.com, hch@infradead.org, clm@fb.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, jk@ozlabs.org
Cc: reiserfs-devel@vger.kernel.org, linux-efi@vger.kernel.org, devel@lists.orangefs.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On 28/06/2019 21:34, Darrick J. Wong wrote:
> Hi all,
> 
> The chattr(1) manpage has this to say about the immutable bit that
> system administrators can set on files:
> 
> "A file with the 'i' attribute cannot be modified: it cannot be deleted
> or renamed, no link can be created to this file, most of the file's
> metadata can not be modified, and the file can not be opened in write
> mode."
> 
> Given the clause about how the file 'cannot be modified', it is
> surprising that programs holding writable file descriptors can continue
> to write to and truncate files after the immutable flag has been set,
> but they cannot call other things such as utimes, fallocate, unlink,
> link, setxattr, or reflink.
> 
> Since the immutable flag is only settable by administrators, resolve
> this inconsistent behavior in favor of the documented behavior -- once
> the flag is set, the file cannot be modified, period.  We presume that
> administrators must be trusted to know what they're doing, and that
> cutting off programs with writable fds will probably break them.
> 

This effort sounds very logical to me and sound. But are we allowed to
do it? IE: Is it not breaking ABI. I do agree previous ABI was evil but
are we allowed to break it?

I would not mind breaking it if %99.99 of the time the immutable bit
was actually set manually by a human administrator. But what if there
are automated systems that set it relying on the current behaviour?

For example I have a very distant and vague recollection of a massive
camera capture system, that was DMAing directly to file (splice). And setting
the immutable bit right away on start. Then once the capture is done
(capture file recycled) the file becomes immutable. Such program is now
broken. Who's fault is it?

I'm totally not sure and maybe you are right. But have you made a
survey of the majority of immutable uses, and are positive that
the guys are not broken after this change?

For me this is kind of scary. Yes I am known to be a SW coward ;-)

Thanks
Boaz
