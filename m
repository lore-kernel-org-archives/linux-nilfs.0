From: nezmer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: Re: Pause intervals when copying/extracting an	archive
Date: Sun, 7 Jun 2009 05:16:46 +0300
Message-ID: <20090607021646.GA5238@nezmer.homelinux.org>
References: <20090606.045653.133237039.ryusuke@osrg.net>
	<20090606134928.GA22242@nezmer.homelinux.org>
	<20090607.001113.60281188.ryusuke@osrg.net>
	<20090607.010336.97022341.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090607.010336.97022341.ryusuke-sG5X7nlA6pw@public.gmane.org>
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

On Sun, Jun 07, 2009 at 01:03:36AM +0900, Ryusuke Konishi wrote:
> On Sun, 07 Jun 2009 00:11:13 +0900 (JST), Ryusuke Konishi wrote:
> > Hi,
> > On Sat, 6 Jun 2009 16:49:28 +0300, nezmer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> > 
> > I think the pause is related to garbage collection.  What will happen
> > if you mount the partition with -i option ?
> > 
> >    # mount -t nilfs2 -i /dev/xxx /mnt/media
> > 
> > This option skips invoking the garbage collector (cleanerd).
> 
> Oops, your log shows the cleanerd is sleeping.
> 
> So, the 5 seconds interval likely comes from regular writeback by the
> segment constructor thread.
> 
> Could you tell me the product name of your USB flash ?
> 
> I will try expansion of a rar file against my pendrive (cruzer)
> 
> Thanks,
> Ryusuke Konishi
> 
> > If it raises throughput, you can adjust by slowing down cleanerd by
> > rewriting /etc/nilfs_cleanerd.conf (a HUP signal must be sent to the
> > cleanerd to reflect the change):
> > 
> >    # The maximum number of segments to be cleaned at a time.
> >  - nsegments_per_clean     2
> >  + nsegments_per_clean     1
> > 
> >    # Cleaning interval in seconds
> >  - cleaning interval       5
> >  + cleaning interval       10
> > 
> > 
> > Thanks,
> > Ryusuke Konishi
> > _______________________________________________
> > users mailing list
> > users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> > https://www.nilfs.org/mailman/listinfo/users

Thank you for your fast replies .

I already tried playing with nilfs_cleanerd.conf & It didn't help .
Mounting with "-i" didn't help either 

Current tests with "tar -xvvf file.tar.gz" where the archive size is
73.8MB & the extraction time is 35-41 seconds in nilfs2 compared to 3-8
seconds in XFS on the same pendrive .

I tested with two completely different pendrives & got the exact same
result so the problem is not model-specific .

If the bug is not reproducible , we can blame it on my system/setup .
