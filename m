From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [SPAM] nilfs and LVM
Date: Thu, 20 Aug 2009 01:31:17 +0900 (JST)
Message-ID: <20090820.013117.36544441.ryusuke@osrg.net>
References: <80225669DEC80D488C4A0B5150466E1802BB436F@dekomplm002.net.plm.eds.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <80225669DEC80D488C4A0B5150466E1802BB436F-q6sIb7dcTNEDs3eufgyKiYGWD8NUZu9dQQ4Iyu8u01E@public.gmane.org>
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

Hi,
On Wed, 19 Aug 2009 10:40:52 +0200, "Barham, David" wrote:
> Can you use nilfs on a partition formed by LVM?
> 
> Background to this question...
> 
> I have a number of PCs which are using Robocopy onto a Samba share as a
> form of backup (server runs SLES 11). I'm trying to use nilfs as a
> method of giving a number of previous days on backup combined with
> taking a tape of the contents of the drive once a week. The data is not
> critical as it should be still held on the PC so I'm ok with the issues
> surrounding the use of nilfs.
> 
>  
> 
> At the moment the size of the partition is ~1.5Tb and the current usage
> is less that 1Tb. However I'm betting this is going to grow. It would be
> much easier to manage going forward if I could just add another disk and
> increase the size of the LV.
> 
>  
> 
> Is this possible?

Unfortunately my answer for this is no.  Resizing nilfs partition is
not supported at present though LVM can increase volume size.

We had an experimental implementation for the resize support, but it
became obsolete during the long mainlining process.

I believe we would have another chance to remake it because it's not
difficult.  Roughly speaking, we can do it by increasing the number of
segments in the partition.  But it may take a few more release cycles
unless someone tries it.

Thanks,
Ryusuke Konishi
