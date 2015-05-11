From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH 2/3] NILFS2: support NFSv2 export
Date: Mon, 11 May 2015 18:54:58 +0900 (JST)
Message-ID: <20150511.185458.913750783836948467.konishi.ryusuke@lab.ntt.co.jp>
References: <20150508001623.31129.25102.stgit@notabene.brown>
	<20150511.013143.706881749197692581.konishi.ryusuke@lab.ntt.co.jp>
	<20150511170251.4fb69e52@notabene.brown>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=+B5w0EmBn4237Xj+BZyZltejTh/I1UExbTsENcYOhio=;
        b=EKqaoGd5MEJ7nNWwphCa+d6n8lp5lb4KT7Vo7za85hMXH4vC3AQQBRE8hSXrxIs3Fv
         73dO4VBUSbUzLU25CsBNVe/EdYFX+G2WDi+/duObNaVaQV1gG5SRlC6wJ+m4vmlxwxNb
         lt9yJ1oXAD9ghhLXx4CP5J7Tx1px7MSs0pfmMk1goOgp5/RESTX2mQR0yY+4kmMcErJK
         zP35MP+wTwyWK1ObXuKD/94n4xaGNP14Aw5Wnemr26J2w+V7yfGT2Aghdmz1YAEinXF4
         8qK0mscyt/ELzo0UM7xgutJZnXWkkxtYnt2d/E3+5NqXSlZZZ0UYsMFrC7YA+DRJUYSb
         kXBg==
In-Reply-To: <20150511170251.4fb69e52@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: NeilBrown <neilb@suse.de>
Cc: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>, Jan Kara <jack@suse.cz>, David Sterba <dsterba@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org

On Mon, 11 May 2015 17:02:51 +1000, NeilBrown wrote:
> On Mon, 11 May 2015 01:31:43 +0900 (JST) Ryusuke Konishi
> <konishi.ryusuke@lab.ntt.co.jp> wrote:
> 
>> On Fri, 08 May 2015 10:16:23 +1000, NeilBrown <neilb@suse.de> wrote:
>> > The "fh_len" passed to ->fh_to_* is not guaranteed to be that same as
>> > that returned by encode_fh - it may be larger.
>> > 
>> > With NFSv2, the filehandle is fixed length, so it may appear longer
>> > than expected and be zero-padded.
>> > 
>> > So we must test that fh_len is at least some value, not exactly equal
>> > to it.
>> > 
>> > Signed-off-by: NeilBrown <neilb@suse.de>
>> > ---
>> >  fs/nilfs2/namei.c |    6 +++---
>> >  1 file changed, 3 insertions(+), 3 deletions(-)
>> > 
>> > diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
>> > index 22180836ec22..b65fb79d16fd 100644
>> > --- a/fs/nilfs2/namei.c
>> > +++ b/fs/nilfs2/namei.c
>> > @@ -496,8 +496,8 @@ static struct dentry *nilfs_fh_to_dentry(struct super_block *sb, struct fid *fh,
>> >  {
>> >  	struct nilfs_fid *fid = (struct nilfs_fid *)fh;
>> >  
>> > -	if ((fh_len != NILFS_FID_SIZE_NON_CONNECTABLE &&
>> > -	     fh_len != NILFS_FID_SIZE_CONNECTABLE) ||
>> 
>> > +	if ((fh_len < NILFS_FID_SIZE_NON_CONNECTABLE &&
>> > +	     fh_len < NILFS_FID_SIZE_CONNECTABLE) ||
>> >  	    (fh_type != FILEID_NILFS_WITH_PARENT &&
>> >  	     fh_type != FILEID_NILFS_WITHOUT_PARENT))
>> >  		return NULL;
>> 
>> A bit weird.  "fh_len < NILFS_FID_SIZE_CONNECTABLE" implies "fh_len <
>> NILFS_FID_SIZE_NON_CONNECTABLE".
>> 
>> How about the following fix ?
>> 
>> 	if ((fh_type != FILEID_NILFS_WITH_PARENT ||
>> 	     fh_len < NILFS_FID_SIZE_CONNECTABLE) &&
>> 	    (fh_type != FILEID_NILFS_WITHOUT_PARENT ||
>> 	     fh_len < NILFS_FID_SIZE_NON_CONNECTABLE))
>> 		return NULL;
>> 
> 
> Yes, weird.  The code only uses the early parts of the filehandle, so we
> only need to complain if the fh_len is less than FILEID_NILFS_WITHOUT_PARENT.
> 
> So I'd prefer:
> 
> @@ -496,8 +496,7 @@ static struct dentry *nilfs_fh_to_dentry(struct super_block *sb, struct fid *fh,
>  {
>         struct nilfs_fid *fid = (struct nilfs_fid *)fh;
>  
> -       if ((fh_len != NILFS_FID_SIZE_NON_CONNECTABLE &&
> -            fh_len != NILFS_FID_SIZE_CONNECTABLE) ||
> +       if (fh_len < NILFS_FID_SIZE_NON_CONNECTABLE ||
>             (fh_type != FILEID_NILFS_WITH_PARENT &&
>              fh_type != FILEID_NILFS_WITHOUT_PARENT))
>                 return NULL;
> 
> 
> Would you be OK with that?  If so I'll resend.
> 
> Thanks,
> NeilBrown

Thanks.  This looks OK to me.
I'll apply it if you will resend.

Regards,
Ryusuke Konishi
