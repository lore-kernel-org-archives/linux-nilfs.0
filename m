From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Number of CheckPoints
Date: Thu, 30 Jul 2009 23:38:49 +0900 (JST)
Message-ID: <20090730.233849.87826385.ryusuke@osrg.net>
References: <4A711C80.1040500@epoch.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <4A711C80.1040500-ZE272gM1l1AAvxtiuMwx3w@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, dfuller-ZE272gM1l1AAvxtiuMwx3w@public.gmane.org

Hi!
On Wed, 29 Jul 2009 21:07:28 -0700, David Fuller wrote:
> Firstly thanks to Robertas for solving my initial problem with cleanerd 
> not running properly on Ubuntu 9.04 .  Upgrading the nilfs tools worked 
> perfectly.

> I was wondering how many checkpoints are kept and for how many days?  I 
> see days worth of checkpoints going back about a week.
>
> Regards,
> --David F.

At present, ``protection period'' is the only parameter determining
the assured lifetime of checkpoints.

You can extend or shrink it by changing /etc/nilfs_cleanerd.conf
conffile, and you can store checkpoints up to the capacity of your
drive.

Note that a HUP signal must be sent to the cleanerd when you reflect
changes on the conffile.


Or you want to know the maximum number of checkpoints ?

OK, here I show some calculation for your information:

The maximum number of checkpoints (or snapshots) is, theoretically,

  2 ^ 64 - 2 = 1.84467441 .. x 10 ^ 19  (about 18.4 exa checkpoints)

In practice, maximum block count limitation will reach before this.

For example, a 32-bit Linux kernel can handle up to 2 ^ 32 blocks.
Since NILFS2 stores 21 checkpoints in a standard 4KB block, 32-bit
nilfs can handle up to

  90,194,313,215 (= about 90.2 giga) checkpoints

If we create a checkpoint per 5 seconds, it corresponds to

  18,038,862,643 seconds = 5,010,795 days = 13,728 years

So the conclusion is, you know, up to the capacity of your drive ;)


Cheers,
Ryusuke Konishi
