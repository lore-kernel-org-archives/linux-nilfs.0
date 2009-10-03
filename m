From: Yuri Chislov <yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org>
Subject: Re: NILFS errors.
Date: Sat, 3 Oct 2009 12:21:33 +0200
Message-ID: <200910031221.34016.yuri@itinteg.net>
References: <200910021246.19909.yuri@itinteg.net>
	<200910021857.28569.yuri@itinteg.net>
	<20091003.131155.120264262.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20091003.131155.120264262.ryusuke-sG5X7nlA6pw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Saturday 03 October 2009 06:11:55 Ryusuke Konishi wrote:
> Well, I guess the corruption didn't come from data loss on the md
> layer.  OTOH, there is a possibility that md behavior has affected
> nilfs.
> 
> Could you confirm if the following patch makes a difference?
> 
> This patch doesn't recover corrupted file system, so you need a new
> file system.  But, this can prevent the directory corruption if it
> came from bio allocation errors on write path.
> 
> The patch was already merged at 2.6.32-rc1 but not yet backported
> to 2.6.31.y and 2.6.30.y.
> 
> If the patch is confirmed to have effect on your problem, I will send
> it to -stable trees.
> 
> Thanks,
> Ryusuke Konishi
> 
> diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
> index 9e3fe17..e6d9e37 100644
> --- a/fs/nilfs2/segbuf.c
> +++ b/fs/nilfs2/segbuf.c
> @@ -316,10 +316,10 @@ static struct bio *nilfs_alloc_seg_bio(struct
>  super_block *sb, sector_t start, {
>         struct bio *bio;
>  
> -       bio = bio_alloc(GFP_NOWAIT, nr_vecs);
> +       bio = bio_alloc(GFP_NOIO, nr_vecs);
>         if (bio == NULL) {
>                 while (!bio && (nr_vecs >>= 1))
> -                       bio = bio_alloc(GFP_NOWAIT, nr_vecs);
> +                       bio = bio_alloc(GFP_NOIO, nr_vecs);
>         }
>         if (likely(bio)) {
>                 bio->bi_bdev = sb->s_bdev;
> 

Thank you for patch. I have install it just now and reformat /dev/md4.
Is it planned some fsck tool? I can help with tests if necessary.

Yuri. 
