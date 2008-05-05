From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: OOM while deleting very large files
Date: Tue, 06 May 2008 02:39:15 +0900 (JST)
Message-ID: <20080506.023915.56055812.ryusuke@osrg.net>
References: <20080504165426.GA2826@laxu.de>
	<20080506.011837.81573783.ryusuke@osrg.net>
	<20080505165331.GA15115@laxu.de>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20080505165331.GA15115-W0ZHf6uU1cg@public.gmane.org>
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
Content-Type: Text/Plain; charset="us-ascii"
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, alex-W0ZHf6uU1cg@public.gmane.org

Hi,

Alexander Schier wrote:
Date: Mon, 5 May 2008 18:53:31 +0200
> For the fixing later:
> PC: 
> CPU: AMD Athlon XP 1,6+
> RAM: 512 MB DDR RAM
> Nilfs2 Version (Module and Tools): 2.0.2
> Partition: 251 GB dmcrypt
> Files: 2x approx. 100 GB created with dd if=/dev/zero of=bigfile, to
> erase the old content on the cryptopartition (the zeros are written
> encrypted to the real partition)

Thanks!

NILFS on dm-crypted partition!  Interesting.

> It is not so important, as i do not need to use such big files further,
> so you can have holydays ;).

Yeah, I will!

Thanks,
Ryusuke Konishi.

> Problem while deleting them as described:
> > > rm bigfile1
> > > 
> > > or after it failed
> > > 
> > > echo '' >bigfile1
> > > 
> > > the pc worked a long time, and then nilfs2 used so much ram, that the
> > > kernel killed all programs, and finally the pc was unusable. It was not
> > > possible to delete the files, other than reformatting the partition.
> 
> Now i'm using the same setup with a nilfs2 with "normal" files on it,
> filled to 11 GB (df -h), without any further problems. 
> 
> I do not want to
> experiment in a way, that the partition needs to be reformatted later
> again :/.
> 
> Alex
