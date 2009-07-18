From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH 3/3] nilfs2: stop using periodic
 write_super callback
Date: Sat, 18 Jul 2009 18:25:32 +0900 (JST)
Message-ID: <20090718.182532.52205748.ryusuke@osrg.net>
References: <1247821968-31232-4-git-send-email-jir@unicus.jp>
	<20090718.030421.01787640.ryusuke@osrg.net>
	<87iqhqqwrq.wl%jir@sekiba.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <87iqhqqwrq.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org

On Sat, 18 Jul 2009 16:24:09 +0900, Jiro SEKIBA wrote:
> At Sat, 18 Jul 2009 03:04:21 +0900 (JST),
> Ryusuke Konishi wrote:
> > >  		if (test_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags) &&
> > >  		    nilfs_discontinued(nilfs)) {
> > 
> > Well, maybe we should change the name of nilfs_discontinued before
> > applying this patch.
> > 
> > It originally meant that the latest log got untraceable from
> > the log which the super block points to.
> > 
> > After applying this patch, the meaning of the flag will change to a
> > state "the superblock needs to be written back".
> 
> I haven't checked yet other place deeply, but if the meaning of the
> nilfs_dicontinued() is still used in the other place, how about 
> defining a macro like following:
> 
> #define nilfs_sb_needed_to_written_back(n) nilfs_discontined((n))

I don't think we have to define the intermediate step because the
related definitions are never used outside nilfs.

But, okay, let's leave renaming the `discontinued' until later. It's
not a priority.

> > > +		t = get_seconds();
> > > +		sbi = sci->sc_sbi;
> > > +	        nilfs = sbi->s_nilfs;
> > > +		if(test_bit(NILFS_SC_SUPER_ROOT, &sci->sc_flags) && 
> > > +	   	   nilfs_update_super(nilfs,t))
> > > +			set_nilfs_discontinued(nilfs);
> > 
> > We need to discuss for this.
> > 
> > At least, the NILFS_SC_SUPER_ROOT bit may be cleared by other tasks
> > outside the transaction lock.
> 
> I see, then it doesn't make sence to check this bit in the thread.
> Reason I've tested the bit is that nilfs_segctor_construct is checking
> that bit when commiting super block.
 
This bit means that the latest log has a super root block, so it's
cleared when the next log is written out.

It makes sense in nilfs_segctor_construct(), but it doesn't in the
thread function.

How about testing sci->sc_super->s_dirt instead ?

Regards,
Ryusuke Konishi
