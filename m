From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] nilfs: check filetype/uid/gid at nilfs_read_inode_common()
Date: Sat, 1 Oct 2022 23:39:25 +0900
Message-ID: <CAKFNMomOwpW6feTDa-PsEVHBySuwt=5hZRtWxqaeaUZkdX2ECw@mail.gmail.com>
References: <000000000000eb0ba805e9d6e30e@google.com> <f1438f46-a52d-707b-4ef9-ab29525f1c98@I-love.SAKURA.ne.jp>
 <4ac809f9-a414-e936-0da1-f943e0551ef2@I-love.SAKURA.ne.jp>
 <CAKFNMom4G5jzSZ_i-kKnykzkhDags+XKYbRZD-cu_FeTVrFMwg@mail.gmail.com> <7d6a80dc-940c-8a64-020d-4a524913512a@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=4KqazxCTvLkfxkm5AfsUxNfKP7jqF68GM9nSLaqwIGc=;
        b=Al8vbn8gcQbfbcbrnFJuMYvif2f+Ah/bqueBaP0kMQEX2XlXSwG1rwYcAsGfZNY6oj
         mmhe9xlZ33L1Y3ABBaszZ+Uef8WMYBmvbQdAYn1Tdn2cQH35svz0yAENvtXXb6cvaxN4
         7LnrgGVEEYaXScpFpfstZKRkArFJUSr3Em3FHDRYXT6wNZ7C6rXTlBdSGX87WPq5VQsF
         5efGOF7bwHYm0qmQ6c6WcllKFRFckfjSruEp/gnTwkAdImwOJnNXzk29hkVewAPu9ReE
         y2TL+2H0aNEY/2ngWEnn2WcTRuDJ+OzvVV6tqRRzJ49rvuG4Sh3Lk6r26bF3amFTWzYJ
         XBBA==
In-Reply-To: <7d6a80dc-940c-8a64-020d-4a524913512a-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzbot+2b32eb36c1a825b7a74c-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org, syzkaller-bugs <syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>

On Sat, Oct 1, 2022 at 11:35 PM Tetsuo Handa wrote:
>
> On 2022/10/01 23:28, Ryusuke Konishi wrote:
> > I think the former is fine because we don't have the idea to add
> > metadata file inodes other
> > than file type.   If you make a revised patch, I will approve or
> > handle it.   Or if you are busy,
> > I will take over the fix.
>
> Please take over the fix. Thank you.

All right,  thank you for your help so far!

Thanks,
Ryusuke Konishi
