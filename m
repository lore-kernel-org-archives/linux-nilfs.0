From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: nilfs_check_page: bad entry in directory #37945
Date: Tue, 17 Mar 2009 00:23:33 +0900 (JST)
Message-ID: <20090317.002333.93458556.ryusuke@osrg.net>
References: <49BE2765.2050200@prnet.org>
	<20090317.000905.79144599.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090317.000905.79144599.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org

On Tue, 17 Mar 2009 00:09:05 +0900 (JST), Ryusuke Konishi wrote:
> Hi David,
> On Mon, 16 Mar 2009 11:18:13 +0100, David Arendt wrote:
> > Hi,
> > 
> > this morning I discovered this in /var/log/messages
> > 
> > Mar 16 10:59:00 server NILFS error (device sda3): nilfs_check_page: bad
> > entry in directory #37945: unaligned directory entry - offset=0,
> > inode=1919250021, rec_len=14411, name_len=67
> >
> > I am using nilfs 2.0.10.
> > 
> > What should I do about this error ? Should I ignore it or should special
> > care be taken about it ?
> > 
> 
> offset=0 --> first entry of the directory.
> inode=1919250021 --> unnatural inode number. seems invalid.
> rec_len=14411 --> invalid.
> 
> So, this directory is completely broken. Maybe b-tree of the directory
> is pointing to a wrong block.
> 
> Is this reproducible by umount/mount and ls -R ?

The directory's inode number was shown in the log!
You can find it by:

 $ find /mount-dir -inum 37945 -ls


Regards,
Ryusuke Konishi
