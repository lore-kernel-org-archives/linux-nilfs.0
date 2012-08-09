From: Christian Smith <csmith-r5H9PUQoNxUga4AWyxku7ULnMzgEhdHr@public.gmane.org>
Subject: Re: nilfs2 not garbage collecting
Date: Thu, 9 Aug 2012 13:46:58 +0100
Message-ID: <20120809124658.GA16953@csmith-bm.vm.bytemark.co.uk>
References: <CANku=ggohcWWoxE1x=XmfWpANKyWRTWb5p_aHh8LU6+utU4OPQ@mail.gmail.com> <3170A27E-46DD-4347-8F9B-FBF4BB4E0205@dubeyko.com> <CANku=gha48jamDmmK6CxVEypryXPniPcgJ3BYa7zYm1EDyYGEg@mail.gmail.com> <2382169.a90FXUemaH@coil>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2382169.a90FXUemaH@coil>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paolo Giangrandi <paolo-UnihLHphgvQ1GQ1Ptb7lUw@public.gmane.org>

On Thu, Aug 09, 2012 at 01:17:30PM +0200, dexen deVries wrote:
> On Thursday 09 of August 2012 12:33:09 you wrote:
> > I'm having some issues at uploading the compressed image (it's "just"
> > 2.3GB, but with my current connection it would take days, I'll upload
> > it on september).
> > 
> > Meanwhile nilfs_cleanerd managed to free some more space (over 1GB),
> > although nothing has changed since yesterday, thus everything seems
> > back to normality.
> > Thanks for the help and see you in september!
> 
> 
> when i'm in a pinch and want cleanerd to free up some space, i run:
> # while true; do killall -HUP nilfs_cleanerd; sleep 4; done
> 
> each `HUP' signal causes cleanerd to both re-read config and run single pass.
> 
> i then monitor progress with
> # iostat -dk 1 /dev/sda
> 
> to see if it is moving data around. if not, i lower `protection_period' in 
> /etc/nilfs_cleanerd.conf; I usually have it set to 7 to 14 days on personal 
> computers, but when /really/ in a squeeze for free space, i lower it to 24h.
> 
> you may also want to increase `nsegments_per_clean' in nilfs_cleanerd.conf to 
> 3 (but not much more; each segment causes up to 8MB of read and write upon 
> each cleanerd pass).


Note, you can do all of this using the nilfs-clean command, which will instruct
nilfs_cleanerd to do one pass of cleaning. I mostly use:

 nilfs-clean -p <prot>		# Override the protection period in nilfs_cleanerd.conf
 nilfs-clean -S <segs>/<secs>	# Clean <segs> segments every <secs> seconds.

I also found the following useful when examining checkpoint usage:

 lscp | grep -C2 ad

The grep captures the active segments at the head of the log, and provides
2 lines of context either side.

Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
