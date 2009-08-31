From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] nilfs2: shorten freeze period due to GC
 in write operation
Date: Mon, 31 Aug 2009 17:14:24 +0900 (JST)
Message-ID: <20090831.171424.08015986.ryusuke@osrg.net>
References: <1251536070-12052-1-git-send-email-jir@unicus.jp>
	<20090831.163729.22914775.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090831.163729.22914775.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Mon, 31 Aug 2009 16:37:29 +0900 (JST), Ryusuke Konishi wrote:
> On Sat, 29 Aug 2009 17:54:30 +0900, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org> wrote:
> >  	nilfs = NILFS_SB(inode->i_sb)->s_nilfs;
> >  
> > +	if (nilfs_gc_running(nilfs))
> > +		return -EBUSY;
> > +	set_nilfs_gc_running(nilfs);
> > +
> 
> Well, I have two comments here on this patch:
> 
> This check and the error return should be done before memory
> allocation of kbufs[4] to avoid memory leak.
> 
> And, logically these bit operations must be atomic by use of
> test_and_set_bit().  So, it should be like:
> 
> 	if (test_and_set_bit(THE_NILFS_GC_RUNNING, &nilfs->ns_flags))
> 		return -EBUSY;
> 
> I think we don't have to expand THE_NILFS_FNS macro for this.

I mean we don't have to add the following template:

static inline void test_and_set_nilfs_##name(struct the_nilfs *nilfs)   \
{                                                                       \
        return test_and_set_bit(THE_NILFS_##bit, &(nilfs)->ns_flags);   \
}

But, it's OK if you prefer this.

Just in case, the use of "THE_NILFS_FNS(GC_RUNNING, gc_running)" looks
proper; you don't have to change clear_nilfs_gc_running() to
"clear_bit(THE_NILFS_GC_RUNNING, &nilfs->ns_flags)".

Thanks,
Ryusuke Konishi
