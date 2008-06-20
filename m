From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: error with ubuntu hardy and nilfs2 on mount
Date: Fri, 20 Jun 2008 19:58:40 +0900 (JST)
Message-ID: <20080620.195840.75273311.ryusuke@osrg.net>
References: <c38b163f0806161058t662d42ffxe590fba6ec2d3075@mail.gmail.com>
	<20080617.085316.32673354.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080617.085316.32673354.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, nadiasvertex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Tue, 17 Jun 2008 08:53:16 +0900 (JST), Ryusuke Konishi wrote:
> On Mon, 16 Jun 2008 13:58:35 -0400, "Christopher Nelson" wrote:
> > root@kraken:/# mkfs -t nilfs2 /dev/sdb2
> > mkfs.nilfs2 ver 2.0
> > Start writing file system initial data to the device
> >        Blocksize:4096  Device:/dev/sdb2  Device Size:491912838144
> > File system initialization succeeded !!
> > root@kraken:/# mount.nilfs2 -vv /dev/sdb2 /work
> > mount.nilfs2: started nilfs_cleanerd
> > Segmentation fault
> > 
> > This with the .18 kernel and the latest modules and tools from nilfs. Also,
> > this is an AMD64 machine.
> > 
> > -={C}=-
> 
> Thanks for reporting the problem.
> This seems to be a bug of the mount.nilfs2 program
> which occurs in case of being invoked without passing through
> /sbin/mount .
> 
> I'll see it later.
> 
> Regards,
> Ryusuke

This bug was fixed in the latest utility package
(nilfs-utils-2.0.4), which is now available on the nilfs site.
The binary packages will also be uploaded soon.

Cheers,
Ryusuke
