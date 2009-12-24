From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: benchmark results
Date: Fri, 25 Dec 2009 00:35:13 +0900 (JST)
Message-ID: <20091225.003513.06978132.ryusuke@osrg.net>
References: <20091224.210645.57462112.ryusuke@osrg.net>
	<alpine.DEB.2.01.0912240415450.3483@bogon.housecafe.de>
	<4B336289.3010608@nerdbynature.de>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4B336289.3010608-AanptEQQ3TL9uQeqpI+JUg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/options/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: lists-AanptEQQ3TL9uQeqpI+JUg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org

On Thu, 24 Dec 2009 04:46:01 -0800, Christian Kujau wrote:
> On Thu, 24 Dec 2009 04:21:13 -0800 (PST), Christian Kujau wrote:
> > On Thu, 24 Dec 2009 at 21:06, Ryusuke Konishi wrote:
> > > > Bonnie++ couldn't complete on nilfs2, only the generic tests 
> > > > and tiobench were run.
> > > 
> > > I looked at the log but couldn't identify the error.
> > > Is that a disk full?
> > 
> > Well, bonnie++ just exits with:
> > 
> >   Create files in sequential order...Can't write data.
> >   Cleaning up test directory after error.
> > 
> > ...which usually means that the disk is full. And I seem to remember that 
> > nilfs2 filesystems were indeed filling up as data is (re)written. However, 
> > I was just curious to test nilfs2 - I'm not even sure things like bonnie++ 
> > are supposed to run at all on a versioning file system :)
> > 
> > I'll try to run a few more nilfs2 tests to find out of it's really an 
> > -ENOSPACE thing.
> 
> I was curious enough to just do that right now:
> 
> $ cat t-nilfs2.sh
> #!/bin/sh
> umount /mnt/d1
> mkfs.nilfs2 /dev/xvdb
> mount -t nilfs2 -o barrier=off /dev/xvdb /mnt/d1
> for i in `seq 1 1000`; do
> 	date
> 	dd if=/dev/zero of=/mnt/d1/file.$i bs=1M count=100 2>/dev/null
> 	sync && rm -v /mnt/d1/file.$i && sync
> 	ls -la /mnt/d1
> 	df -k /mnt/d1 | grep -v Files
> 	echo
> done
> --------------
> 
> So, basically I'm just writing 100MB to nilfs, then deleting the file 
> again, sync and making sure that file.$i has been indeed deleted. Here's 
> just the output from the df(1) commands:
> 
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/xvdb              2088956    114684   1867776   6% /mnt/d1
> /dev/xvdb              2088956    221180   1761280  12% /mnt/d1
> /dev/xvdb              2088956    327676   1654784  17% /mnt/d1
> /dev/xvdb              2088956    434172   1548288  22% /mnt/d1
> /dev/xvdb              2088956    524284   1458176  27% /mnt/d1
> /dev/xvdb              2088956    638972   1343488  33% /mnt/d1
> /dev/xvdb              2088956    745468   1236992  38% /mnt/d1
> /dev/xvdb              2088956    835580   1146880  43% /mnt/d1
> /dev/xvdb              2088956    958460   1024000  49% /mnt/d1
> /dev/xvdb              2088956   1056764    925696  54% /mnt/d1
> /dev/xvdb              2088956   1163260    819200  59% /mnt/d1
> /dev/xvdb              2088956   1261564    720896  64% /mnt/d1
> /dev/xvdb              2088956   1368060    614400  70% /mnt/d1
> /dev/xvdb              2088956   1482748    499712  75% /mnt/d1
> /dev/xvdb              2088956   1572860    409600  80% /mnt/d1
> /dev/xvdb              2088956   1687548    294912  86% /mnt/d1
> /dev/xvdb              2088956   1794044    188416  91% /mnt/d1
> /dev/xvdb              2088956   1892348     90112  96% /mnt/d1
> /dev/xvdb              2088956   1957884     24576  99% /mnt/d1
> /dev/xvdb              2088956   1974268      8192 100% /mnt/d1
> /dev/xvdb              2088956   1974268      8192 100% /mnt/d1
> /dev/xvdb              2088956   1974268      8192 100% /mnt/d1
> [...]
> 
> With 8K free, dd(1) was unable to write any data to the filesystem. This 
> is all with Linux 2.6.32 (x86-64) and nilfs2-tools 2.0.14-5, but I think 
> this happened with earlier kernels too. Again, perhaps nilfs2 is 
> supposed to work that way, somewhere the "old" versions of the 
> filesystem have to be stored and this the fs fills up of course - but 
> you tell me :-)
> 
> Christian.

Thank you for the quick responses.

Yes, nilfs -- more precisely garbage collector of nilfs, by its
nature, preserves old data within a period of time.  So, it usually
needs some care for this kind of test.  Benchmark programs make fair
amount of changes for the short run, by its very nature ;)

Anyway, I'm relieved for now.

Thanks,
Ryusuke Konishi
