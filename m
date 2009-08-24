From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH:v2] nilfs2: tune write performance
Date: Tue, 25 Aug 2009 02:47:39 +0900 (JST)
Message-ID: <20090825.024739.58892488.ryusuke@osrg.net>
References: <1250155393-29046-1-git-send-email-jir@unicus.jp>
	<20090813.200606.92732522.ryusuke@osrg.net>
	<878whnf9as.wl%jir@sekiba.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <878whnf9as.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
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
To: jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org
Cc: konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,
On Fri, 14 Aug 2009 10:55:55 +0900, Jiro SEKIBA wrote:
> Hi, 
> 
> At Thu, 13 Aug 2009 20:06:06 +0900 (JST),
> Ryusuke Konishi wrote:
> > 
> > Hi Sekiba-san,
> > On Thu, 13 Aug 2009 18:23:13 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> > > Hi,
> > > 
> > > This is a revised patch of write performance patch.
> > > 
> > > When GC is runnning, GC moves live block to difference segments.
> > > Copying live blocks into memory is done in a transaction,
> > > but it is not necessarily to be in the transaction.
> > > This patch will get the nilfs_ioctl_move_blocks() out from
> > > transaction lock and put it before the transaction.
<snip>

> > > Signed-off-by: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
> > > ---
> > >  fs/nilfs2/ioctl.c |   14 ++++++++------
> > >  1 files changed, 8 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> > > index 6ea5f87..35cd0ff 100644
> > > --- a/fs/nilfs2/ioctl.c
> > > +++ b/fs/nilfs2/ioctl.c
> > > @@ -442,12 +442,6 @@ int nilfs_ioctl_prepare_clean_segments(struct the_nilfs *nilfs,
> > >  	const char *msg;
> > >  	int ret;
> > >  
> > > -	ret = nilfs_ioctl_move_blocks(nilfs, &argv[0], kbufs[0]);
> > > -	if (ret < 0) {
> > > -		msg = "cannot read source blocks";
> > > -		goto failed;
> > > -	}
> > > -
> > >  	ret = nilfs_ioctl_delete_checkpoints(nilfs, &argv[1], kbufs[1]);
> > >  	if (ret < 0) {
> > >  		/*
> > > @@ -548,6 +542,14 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
> > >  		}
> > >  	}
> > >  
> > > +	ret = nilfs_ioctl_move_blocks(nilfs, &argv[0], kbufs[0]);
> > > +	if (ret < 0) {
> > > +		nilfs_remove_all_gcinode(nilfs);
> > > +		printk(KERN_ERR "NILFS: GC failed during preparation: "
> > > +			"cannot read source blocks: err=%d\n", ret);
> > > +		goto out_free;
> > > +	}
> > > +
> > >  	ret = nilfs_clean_segments(inode->i_sb, argv, kbufs);
> > >  
> > >   out_free:
> > > -- 
> > > 1.5.6.5

I noticed there is a problem in this patch.

The nilfs_remove_all_gcinode() function and the
nilfs_ioctl_move_blocks() function manipulate a list and a hash table
of inodes which hold blocks to be moved in garbage collection.

However, these are not protected outside the log-writer lock
(i.e. transaction lock).  Although this ioctl function is usually not
called simulataneously, you have to introduce new protection in order
to make a series of operations on the inode list and the hash table
atomic.

I think this can be simply handled by adding a new GC state bit to the
nilfs->ns_flags.

Could you look back the code around gcinode.c please ?

Thanks,
Ryusuke Konishi
