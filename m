From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [SPAM] RE: [SPAM] installation/getting started
 issues onSLES 11
Date: Thu, 13 Aug 2009 23:34:42 +0900 (JST)
Message-ID: <20090813.233442.53068697.ryusuke@osrg.net>
References: <80225669DEC80D488C4A0B5150466E1802BB39E7@dekomplm002.net.plm.eds.com>
	<871d267c0908121832mcabe0b9ub9cdf8fbb8117f0c@mail.gmail.com>
	<80225669DEC80D488C4A0B5150466E1802BB3B11@dekomplm002.net.plm.eds.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <80225669DEC80D488C4A0B5150466E1802BB3B11-q6sIb7dcTNEDs3eufgyKiYGWD8NUZu9dQQ4Iyu8u01E@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, david.barham-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org

On Thu, 13 Aug 2009 14:02:03 +0200, "Barham, David" wrote:
> Many thanks
> 
> That make it all work!
> 
> Perhaps this would be worth adding to the installation notes on the
> website.

Yep, I will. 
  
Cheers,
Ryusuke Konishi


> From: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org [mailto:users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org] On Behalf
> Of Zhang Qiang
> Sent: 13 August 2009 02:32
> To: NILFS Users mailing list
> Subject: Re: [NILFS users] [SPAM] installation/getting started issues
> onSLES 11
> 
>  
> 
> Hi,
> Have you install the nilfs2 kernel module[nilfs2.ko].
> 
> This error info seems show that the nilfs2 filesystem type have not
> registered on your system, and you should do 'insmod nilfs2.ko'.  Is
> this module included in nilfs-kmp-default-2.0.15_2.6.
> 
> 27.19_5-2.1.x86_64.rpm?
> 
> 
> Expect this info can help you.
> 
> -Regards
> -Qiang
> 
> 
> 
> 2009/8/12 Barham, David <david.barham-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
> 
> I've just downloaded and installed the RPMs for SLES 11 from
> opensuse.org.
> 
> I've successfully installed
> nilfs-kmp-default-2.0.15_2.6.27.19_5-2.1.x86_64.rpm and
> nilfs-utils-2.0.14-4.2.x86_64.rpm.
> 
>  
> 
> These installed with no error.
> 
>  
> 
> Mkfs appears to work without error.
> 
>  
> 
> # mkfs -t nilfs2 /dev/sdb
> 
> mkfs.nilfs2 ver 2.0
> 
> Start writing file system initial data to the device
> 
>        Blocksize:4096  Device:/dev/sdb  Device Size:1500301910016
> 
> File system initialization succeeded !!
> 
>  
> 
> But when I tried to mount the filesystem I get
> 
>  
> 
> # mount -t nilfs2 /dev/sdb /data1
> 
> mount.nilfs2: WARNING! - The NILFS on-disk format may change at any
> time.
> 
> mount.nilfs2: WARNING! - Do not place critical data on a NILFS
> filesystem.
> 
> mount.nilfs2: cannot find or load nilfs2 filesystem
> 
>  
> 
> Any ideas? I can see an /sbin/mount.nilfs2 and all the other files I
> would expect.
> 
>  
> 
> Is this a terrible newbie misunderstanding? 
> 
> What am I doing wrong? 
> 
> Am I missing some other vital rpm?
> 
>  
> 
> Thanks
> 
> David Barham
