From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Fail to mount NILFS.
Date: Tue, 25 Aug 2009 02:33:49 +0900 (JST)
Message-ID: <20090825.023349.64850558.ryusuke@osrg.net>
References: <20090823.220941.57456918.ryusuke@osrg.net>
	<20090825.010847.29421896.ryusuke@osrg.net>
	<200908241921.35124.yuri@itinteg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <200908241921.35124.yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org>
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
To: yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,
On Mon, 24 Aug 2009 19:21:35 +0300, Yuri Chislov wrote:
> On Monday 24 August 2009 19:08:47 you wrote:
> > Could you send me the two dump files taken by the following steps ?
> >
> >  # dd if=/dev/cciss/c0d1p1 bs=4k count=1 skip=3280927 | hd > blk3280927.log
> >  # expr 3280927 / 2048
> >  1602
> >  # dumpseg /dev/cciss/c0d1p1 1602 > seg1602.log
> Hi,
> 
>  As I understand hd is hexdump alias.
> Archive with files attached.
> 
> Thanks.
> Yuri. 

Thank you for your very quick response ;)

The segment was unfortunately overwritten with irrelevant files, and
the block was not that of the root inode.

According to the log, it happened on 20th August 12:22:24.


I guess garbage collector mistakenly reclaimed the segment without
moving the root inode block to a new place.

For debugging, I want to know the content of the DAT block located at
#22241917.

Could you give me a hand one more time, please?

  # dd if=/dev/cciss/c0d1p1 of=blk22241917 bs=4k count=1 skip=22241917
  # expr 22241917 / 2048
  10860
  # dumpseg /dev/cciss/c0d1p1 10860 > seg10860.log

Thanks,
Ryusuke Konishi
